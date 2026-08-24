import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:pulse/core/constants/mood.dart';

class MoodKeyword {
  final String phrase;
  final double weight;
  const MoodKeyword(this.phrase, this.weight);
}

@lazySingleton
class MoodDetectionService {
  final http.Client _client;

  MoodDetectionService({http.Client? client})
      : _client = client ?? http.Client();

  // Simple LRU cache
  final Map<String, Mood> _cache = {};
  static const int _maxCacheSize = 100;

  // ─── Confidence thresholds ────────────────────────────────────────────────
  // If keyword score >= _highConfidenceThreshold → return immediately
  // If keyword score >= _lowConfidenceThreshold  → return without calling AI
  // If keyword score <  _lowConfidenceThreshold  → call Gemini as fallback
  static const double _highConfidenceThreshold = 2.0;
  static const double _lowConfidenceThreshold = 0.8;

  static const String _systemPrompt = '''
You are a mood classifier for a chat messaging app.
Classify the given message into EXACTLY ONE of these moods: happy, sad, angry, anxious, excited, neutral.
Respond ONLY with the single mood word in lowercase.
Do NOT use markdown, punctuation, colons, asterisks, or any extra text.
Your entire response must be a single word only.

Examples:
- "انا زعلان" -> sad
- "I'm so happy" -> happy
- "مش طايق نفسي" -> angry
- "خايف من الامتحان" -> anxious
- "مش مصدق واخيرااا" -> excited
- "ازيك عامل ايه" -> neutral
- "حزين" -> sad
- "I'm not happy" -> sad
- "don't worry about it" -> neutral
''';

  // ─── PUBLIC API ───────────────────────────────────────────────────────────

  Future<Mood> detectMood(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return Mood.neutral;

    final cacheKey = trimmed.toLowerCase();

    // Cache hit
    if (_cache.containsKey(cacheKey)) {
      log('⚡ Cache hit: "$trimmed"', name: 'MoodDetection');
      return _cache[cacheKey]!;
    }

    final stopwatch = Stopwatch()..start();

    // Step 1 — Keyword scoring
    final scores = _scoreAll(trimmed);

    final bestEntry =
        scores.entries.reduce((a, b) => a.value > b.value ? a : b);
    final bestMood = bestEntry.key;
    final bestScore = bestEntry.value;

    // Step 2 — High confidence → return immediately
    if (bestScore >= _highConfidenceThreshold) {
      stopwatch.stop();
      log('✅ High-confidence: $bestMood (${bestScore.toStringAsFixed(2)}) in ${stopwatch.elapsedMilliseconds}ms',
          name: 'MoodDetection');
      _addToCache(cacheKey, bestMood);
      return bestMood;
    }

    // Step 3 — Low confidence → return keyword result
    if (bestScore >= _lowConfidenceThreshold) {
      stopwatch.stop();
      log('✅ Low-confidence: $bestMood (${bestScore.toStringAsFixed(2)}) in ${stopwatch.elapsedMilliseconds}ms',
          name: 'MoodDetection');
      _addToCache(cacheKey, bestMood);
      return bestMood;
    }

    // Step 4 — No signal → Gemini fallback
    log('🤖 No keyword signal — calling Gemini for: "$trimmed"',
        name: 'MoodDetection');

    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty || apiKey == 'your_gemini_api_key_here') {
      stopwatch.stop();
      log('⚠️ No API key — returning neutral', name: 'MoodDetection');
      return Mood.neutral;
    }

    try {
      final aiMood = await _callGemini(trimmed, apiKey)
          .timeout(const Duration(seconds: 3));
      stopwatch.stop();
      final result = aiMood ?? Mood.neutral;
      log('🎯 Gemini result: $result in ${stopwatch.elapsedMilliseconds}ms',
          name: 'MoodDetection');
      _addToCache(cacheKey, result);
      return result;
    } catch (e) {
      stopwatch.stop();
      log('❌ Gemini failed after ${stopwatch.elapsedMilliseconds}ms: $e',
          name: 'MoodDetection');
      return Mood.neutral;
    }
  }

  // ─── KEYWORD SCORING ─────────────────────────────────────────────────────

  Map<Mood, double> _scoreAll(String text) {
    final normalized = normalizeText(text);

    final scores = <Mood, double>{
      Mood.excited: _scoreKeywords(normalized, excitedKeywords) +
          _scoreEmojis(text, excitedEmojis),
      Mood.happy: _scoreKeywords(normalized, happyKeywords) +
          _scoreEmojis(text, happyEmojis),
      Mood.sad: _scoreKeywords(normalized, sadKeywords) +
          _scoreEmojis(text, sadEmojis),
      Mood.angry: _scoreKeywords(normalized, angryKeywords) +
          _scoreEmojis(text, angryEmojis),
      Mood.anxious: _scoreKeywords(normalized, anxiousKeywords) +
          _scoreEmojis(text, anxiousEmojis),
      Mood.neutral: 0,
    };

    // Punctuation boosts
    final exclamationCount = '!'.allMatches(text).length;
    final questionCount = '?'.allMatches(text).length;

    if (exclamationCount > 0) {
      scores[Mood.excited] =
          (scores[Mood.excited] ?? 0) + (exclamationCount >= 3 ? 0.8 : 0.3);
      scores[Mood.happy] =
          (scores[Mood.happy] ?? 0) + (exclamationCount >= 3 ? 0.3 : 0.1);
      if (exclamationCount >= 2) {
        scores[Mood.angry] = (scores[Mood.angry] ?? 0) + 0.2;
      }
    }

    if (questionCount >= 2) {
      scores[Mood.anxious] = (scores[Mood.anxious] ?? 0) + 0.3;
    }

    // Uppercase boost
    final uppercaseRatio = _uppercaseRatio(text);
    if (uppercaseRatio >= 0.65 && text.length >= 6) {
      scores[Mood.excited] = (scores[Mood.excited] ?? 0) + 0.3;
      scores[Mood.angry] = (scores[Mood.angry] ?? 0) + 0.2;
    }

    // Negation handling
    _applyNegation(normalized, scores);

    return scores;
  }

  double _scoreKeywords(String normalizedText, List<MoodKeyword> keywords) {
    double score = 0;
    for (final keyword in keywords) {
      final normalizedKeyword = normalizeText(keyword.phrase);
      if (normalizedKeyword.isEmpty) continue;
      if (normalizedText.contains(normalizedKeyword)) {
        score += keyword.weight;
      }
    }
    return score;
  }

  double _scoreEmojis(String originalText, List<MoodKeyword> emojis) {
    double score = 0;
    for (final emoji in emojis) {
      if (originalText.contains(emoji.phrase)) {
        score += emoji.weight;
      }
    }
    return score;
  }

  // ─── GEMINI FALLBACK ─────────────────────────────────────────────────────

  Future<Mood?> _callGemini(String message, String apiKey) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent?key=$apiKey',
    );

    final payload = {
      'system_instruction': {
        'parts': [
          {'text': _systemPrompt}
        ]
      },
      'contents': [
        {
          'parts': [
            {'text': message}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.0,
        'maxOutputTokens': 5,
        'stopSequences': ['\n', '.', ',', ':'],
      },
    };

    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = data['candidates'] as List<dynamic>?;
      if (candidates != null && candidates.isNotEmpty) {
        final content = candidates.first['content'] as Map<String, dynamic>?;
        final parts = content?['parts'] as List<dynamic>?;
        if (parts != null && parts.isNotEmpty) {
          final rawText = parts.first['text'] as String? ?? '';
          return _parseMood(rawText.trim().toLowerCase());
        }
      }
    }
    return null;
  }

  Mood _parseMood(String response) {
    final cleaned = response.replaceAll(RegExp(r'[^a-z]'), '');

    switch (cleaned) {
      case 'happy':
        return Mood.happy;
      case 'sad':
        return Mood.sad;
      case 'angry':
        return Mood.angry;
      case 'anxious':
        return Mood.anxious;
      case 'excited':
        return Mood.excited;
      case 'neutral':
        return Mood.neutral;
    }

    // Partial match
    for (final mood in Mood.values) {
      if (cleaned.contains(mood.name)) return mood;
    }

    // Raw match before cleaning
    for (final mood in Mood.values) {
      if (response.contains(mood.name)) return mood;
    }

    return Mood.neutral;
  }

  // ─── NEGATION ────────────────────────────────────────────────────────────

  void _applyNegation(String text, Map<Mood, double> score) {
    final positiveNegations = [
      'not happy',
      'not good',
      'not nice',
      'not great',
      'not feeling good',
      'not feeling great',
      'dont like',
      "don't like",
      'do not like',
      'dont love',
      "don't love",
      'do not love',
      'not excited',
      'not amazing',
      'not okay actually',
      'not fine',
      'not proud',
      'not comfortable',
      'مش مبسوط',
      'مش مبسوطه',
      'مش سعيد',
      'مش سعيده',
      'مش فرحان',
      'مش فرحانه',
      'مش كويس',
      'مش كويسه',
      'مش تمام',
      'مش متحمس',
      'مش متحمسه',
    ];

    final sadNegations = [
      'not sad',
      'not unhappy',
      'not lonely',
      'not crying',
      'not depressed',
      'not miserable',
      'not hopeless',
      'مش حزين',
      'مش حزينه',
      'مش زعلان',
      'مش زعلانه',
      'مش وحيد',
      'مش وحيده',
      'مش بعيط',
      'مش مكتئب',
      'مش مكتئبه',
    ];

    final anxiousNegations = [
      'not worried',
      'not anxious',
      'not scared',
      'not afraid',
      'not nervous',
      'not stressed',
      'not panicking',
      'dont worry',
      "don't worry",
      'do not worry',
      'مش قلقان',
      'مش قلقانه',
      'مش خايف',
      'مش خايفه',
      'مش متوتر',
      'مش متوتره',
    ];

    final angryNegations = [
      'not angry',
      'not mad',
      'not furious',
      'not upset',
      'not annoyed',
      'مش عصبي',
      'مش عصبيه',
      'مش غاضب',
      'مش غاضبه',
    ];

    for (final phrase in positiveNegations) {
      if (text.contains(normalizeText(phrase))) {
        score[Mood.happy] = (score[Mood.happy] ?? 0) * 0.25;
        score[Mood.excited] = (score[Mood.excited] ?? 0) * 0.35;
        score[Mood.sad] = (score[Mood.sad] ?? 0) + 0.4;
      }
    }
    for (final phrase in sadNegations) {
      if (text.contains(normalizeText(phrase))) {
        score[Mood.sad] = (score[Mood.sad] ?? 0) * 0.25;
      }
    }
    for (final phrase in anxiousNegations) {
      if (text.contains(normalizeText(phrase))) {
        score[Mood.anxious] = (score[Mood.anxious] ?? 0) * 0.25;
      }
    }
    for (final phrase in angryNegations) {
      if (text.contains(normalizeText(phrase))) {
        score[Mood.angry] = (score[Mood.angry] ?? 0) * 0.25;
      }
    }
  }

  // ─── UPPERCASE ───────────────────────────────────────────────────────────

  double _uppercaseRatio(String text) {
    final letters = text.runes
        .map(String.fromCharCode)
        .where((char) => RegExp(r'[A-Za-z]').hasMatch(char))
        .toList();
    if (letters.isEmpty) return 0;
    final uppercase =
        letters.where((char) => char == char.toUpperCase()).length;
    return uppercase / letters.length;
  }

  // ─── NORMALIZATION ───────────────────────────────────────────────────────

  String normalizeText(String input) {
    var text = input.toLowerCase().trim();

    text = text
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ٱ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي');

    text = text.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
    text = text.replaceAll('ـ', '');

    text = text
        .replaceAll('،', ' ')
        .replaceAll('؛', ' ')
        .replaceAll('؟', ' ')
        .replaceAll('«', ' ')
        .replaceAll('»', ' ')
        .replaceAll('"', ' ')
        .replaceAll('"', ' ')
        .replaceAll(''', "'")
        .replaceAll(''', "'");

    text = text.replaceAll(RegExp(r'(.)\1{2,}'), r'$1$1');

    text = text.replaceAll(RegExp(r"[^\u0600-\u06FFa-z0-9\s']"), ' ');

    text = text.replaceAll(RegExp(r'\s+'), ' ');

    return text.trim();
  }

  // ─── CACHE ───────────────────────────────────────────────────────────────

  void _addToCache(String key, Mood mood) {
    if (_cache.length >= _maxCacheSize) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = mood;
  }

  void clearCache() => _cache.clear();

  // ─── KEYWORDS (paste your full lists here) ────────────────────────────────

  static const excitedKeywords = <MoodKeyword>[
    // English - single words
    MoodKeyword('amazing', 2.0),
    MoodKeyword('awesome', 2.0),
    MoodKeyword('fantastic', 2.0),
    MoodKeyword('incredible', 2.0),
    MoodKeyword('wonderful', 1.8),
    MoodKeyword('excellent', 1.8),
    MoodKeyword('brilliant', 1.8),
    MoodKeyword('outstanding', 1.8),
    MoodKeyword('superb', 1.8),
    MoodKeyword('perfect', 1.5),
    MoodKeyword('spectacular', 2.0),
    MoodKeyword('phenomenal', 2.0),
    MoodKeyword('extraordinary', 2.0),
    MoodKeyword('magnificent', 2.0),
    MoodKeyword('marvelous', 1.8),
    MoodKeyword('fabulous', 1.8),
    MoodKeyword('terrific', 1.8),
    MoodKeyword('bravo', 1.5),
    MoodKeyword('yay', 2.0),
    MoodKeyword('woohoo', 2.0),
    MoodKeyword('wohoo', 2.0),
    MoodKeyword('woot', 2.0),
    MoodKeyword('whoop', 1.8),
    MoodKeyword('wow', 1.5),
    MoodKeyword('omg', 1.5),
    MoodKeyword('insane', 1.5),
    MoodKeyword('unbelievable', 1.8),
    MoodKeyword('thrilled', 2.2),
    MoodKeyword('ecstatic', 2.5),
    MoodKeyword('pumped', 2.0),
    MoodKeyword('stoked', 2.0),
    MoodKeyword('hyped', 2.0),
    MoodKeyword('excited', 2.2),
    MoodKeyword('exciting', 1.8),
    MoodKeyword('epic', 1.8),
    MoodKeyword('legendary', 1.8),
    MoodKeyword('fire', 1.5),
    MoodKeyword('lit', 1.5),
    MoodKeyword('dope', 1.5),
    MoodKeyword('sick', 1.2),
    MoodKeyword('goated', 1.8),
    MoodKeyword('goat', 1.5),
    MoodKeyword('winning', 1.8),
    MoodKeyword('victory', 1.8),
    MoodKeyword('celebration', 1.8),
    MoodKeyword('celebrate', 1.8),
    MoodKeyword('celebrating', 1.8),
    MoodKeyword('finally', 1.2),
    MoodKeyword('yes', 1.0),
    MoodKeyword('yess', 1.5),
    MoodKeyword('yesss', 2.0),
    MoodKeyword('yass', 2.0),
    MoodKeyword('yasss', 2.0),
    MoodKeyword('letsgo', 2.0),
    // English - single words (expanded)
    MoodKeyword('buzzing', 1.8),
    MoodKeyword('geeked', 2.0),
    MoodKeyword('amped', 2.0),
    MoodKeyword('unreal', 1.8),
    MoodKeyword('rad', 1.5),
    MoodKeyword('killer', 1.5),
    MoodKeyword('banger', 1.8),
    MoodKeyword('slaps', 1.8),
    MoodKeyword('iconic', 1.5),
    MoodKeyword('sensational', 2.0),
    MoodKeyword('remarkable', 1.5),
    MoodKeyword('astonishing', 2.0),
    MoodKeyword('astounding', 2.0),
    MoodKeyword('breathtaking', 2.0),
    MoodKeyword('dazzling', 1.8),
    MoodKeyword('thrilling', 2.0),
    MoodKeyword('exhilarating', 2.2),
    MoodKeyword('electrifying', 2.0),
    MoodKeyword('invigorating', 1.8),
    MoodKeyword('energized', 1.8),
    MoodKeyword('giddy', 2.0),
    MoodKeyword('yippee', 2.0),
    MoodKeyword('hooray', 2.0),
    MoodKeyword('hurray', 2.0),
    MoodKeyword('bingo', 1.5),
    MoodKeyword('jackpot', 1.8),
    MoodKeyword('boom', 1.3),
    MoodKeyword('yeehaw', 1.8),
    MoodKeyword('milestone', 1.5),
    MoodKeyword('breakthrough', 1.8),

    // English - phrases
    MoodKeyword("let's go", 2.2),
    MoodKeyword('lets go', 2.2),
    MoodKeyword('lets do this', 2.0),
    MoodKeyword("let's do this", 2.0),
    MoodKeyword('bring it on', 1.8),
    MoodKeyword('here we go', 1.5),
    MoodKeyword('i am excited', 2.5),
    MoodKeyword("i'm excited", 2.5),
    MoodKeyword('so excited', 2.5),
    MoodKeyword('really excited', 2.5),
    MoodKeyword('super excited', 2.5),
    MoodKeyword('extremely excited', 2.5),
    MoodKeyword('very excited', 2.5),
    MoodKeyword('cant wait', 2.0),
    MoodKeyword("can't wait", 2.0),
    MoodKeyword('cannot wait', 2.0),
    MoodKeyword('i cannot wait', 2.3),
    MoodKeyword("i can't wait", 2.3),
    MoodKeyword("i'm so excited", 2.8),
    MoodKeyword('this is amazing', 2.5),
    MoodKeyword('this is awesome', 2.5),
    MoodKeyword('this is incredible', 2.5),
    MoodKeyword('this is fantastic', 2.5),
    MoodKeyword('best day ever', 2.5),
    MoodKeyword('best thing ever', 2.5),
    MoodKeyword('what a day', 1.5),
    MoodKeyword('what a moment', 1.8),
    MoodKeyword('so happy right now', 2.0),
    MoodKeyword('i am so happy', 2.0),
    MoodKeyword("i'm so happy", 2.0),
    MoodKeyword('i am loving this', 1.8),
    MoodKeyword("i'm loving this", 1.8),
    MoodKeyword('this is the best', 2.0),
    MoodKeyword('we did it', 2.2),
    MoodKeyword('we made it', 2.0),
    MoodKeyword('finally made it', 2.0),
    MoodKeyword('dream come true', 2.5),
    MoodKeyword('living the dream', 2.0),
    MoodKeyword('so proud right now', 1.8),
    // English - phrases (expanded)
    MoodKeyword('over the moon', 2.5),
    MoodKeyword('on cloud nine', 2.5),
    MoodKeyword('on top of the world', 2.3),
    MoodKeyword('walking on air', 2.2),
    MoodKeyword('blown away', 2.2),
    MoodKeyword('mind blown', 2.2),
    MoodKeyword('jaw dropped', 2.0),
    MoodKeyword('no way', 1.5),
    MoodKeyword('holy cow', 1.8),
    MoodKeyword('holy moly', 1.8),
    MoodKeyword('fired up', 2.0),
    MoodKeyword('amped up', 2.0),
    MoodKeyword('charged up', 1.8),
    MoodKeyword('raring to go', 2.0),
    MoodKeyword('jumping for joy', 2.3),
    MoodKeyword('beside myself', 2.0),
    MoodKeyword("can't sit still", 2.0),
    MoodKeyword('revved up', 1.8),
    MoodKeyword('super stoked', 2.3),
    MoodKeyword('absolutely thrilled', 2.5),
    MoodKeyword('beyond excited', 2.6),
    MoodKeyword('super hyped', 2.3),
    MoodKeyword('this is huge', 2.0),
    MoodKeyword('huge news', 2.0),
    MoodKeyword('big news', 1.8),
    MoodKeyword("can't believe it", 2.0),
    MoodKeyword('no freaking way', 2.0),
    MoodKeyword('sign me up', 1.8),
    MoodKeyword('count me in', 1.8),
    MoodKeyword("i'm all in", 1.8),
    MoodKeyword('bucket list', 1.5),
    MoodKeyword('dream job', 2.0),
    MoodKeyword('once in a lifetime', 2.2),
    MoodKeyword('achievement unlocked', 2.0),
    MoodKeyword('level up', 1.8),
    MoodKeyword('leveled up', 1.8),
    MoodKeyword('crushing it', 2.0),
    MoodKeyword('killing it', 2.0),
    MoodKeyword('nailed it', 2.0),
    MoodKeyword('smashed it', 2.0),
    MoodKeyword('aced it', 2.0),
    MoodKeyword('top notch', 1.8),
    MoodKeyword('first class', 1.5),
    MoodKeyword('world class', 1.8),
    MoodKeyword('five stars', 1.8),
    MoodKeyword('ten out of ten', 1.8),
    MoodKeyword("chef's kiss", 1.8),

    // Arabic - MSA
    MoodKeyword('متحمس', 2.0),
    MoodKeyword('متحمسة', 2.0),
    MoodKeyword('حماس', 1.8),
    MoodKeyword('متحمس جدا', 2.5),
    MoodKeyword('متحمسة جدا', 2.5),
    MoodKeyword('متحمس جدًا', 2.5),
    MoodKeyword('متحمسة جدًا', 2.5),
    MoodKeyword('سعيد جدا', 2.0),
    MoodKeyword('سعيدة جدا', 2.0),
    MoodKeyword('فرح شديد', 2.0),
    MoodKeyword('فرح كبير', 2.0),
    MoodKeyword('مبتهج', 2.0),
    MoodKeyword('مبتهجة', 2.0),
    MoodKeyword('مسرور', 2.0),
    MoodKeyword('مسرورة', 2.0),
    MoodKeyword('رائع جدا', 2.0),
    MoodKeyword('رائعة جدا', 2.0),
    MoodKeyword('مذهل', 2.0),
    MoodKeyword('مذهلة', 2.0),
    MoodKeyword('ممتاز', 1.8),
    MoodKeyword('ممتازة', 1.8),
    MoodKeyword('مدهش', 2.0),
    MoodKeyword('مدهشة', 2.0),
    MoodKeyword('رائع', 1.8),
    MoodKeyword('رائعة', 1.8),
    MoodKeyword('يا له من شيء رائع', 2.0),
    MoodKeyword('لا استطيع الانتظار', 2.5),
    MoodKeyword('لا أستطيع الانتظار', 2.5),
    MoodKeyword('هذا رائع', 2.0),
    MoodKeyword('هذا مذهل', 2.0),
    MoodKeyword('هذا جميل جدا', 1.8),
    MoodKeyword('هذا جميل جدًا', 1.8),
    MoodKeyword('يا سلام', 1.5),
    MoodKeyword('يا سلام على', 1.5),
    MoodKeyword('الحمد لله', 1.5),
    MoodKeyword('الحمدلله', 1.5),
    // Arabic - MSA (expanded)
    MoodKeyword('بهجة', 1.8),
    MoodKeyword('انتشاء', 2.0),
    MoodKeyword('نشوة', 2.0),
    MoodKeyword('حبور', 1.8),
    MoodKeyword('غبطة', 1.8),
    MoodKeyword('تهلل', 1.8),
    MoodKeyword('مفاجأة سارة', 2.0),
    MoodKeyword('مفاجأة سعيدة', 2.0),
    MoodKeyword('خبر سار', 2.0),
    MoodKeyword('خبر رائع', 2.0),
    MoodKeyword('نجاح باهر', 2.2),
    MoodKeyword('إنجاز عظيم', 2.2),
    MoodKeyword('حلم تحقق', 2.3),
    MoodKeyword('لحظة تاريخية', 1.8),
    MoodKeyword('يوم لا ينسى', 1.8),
    MoodKeyword('أفضل يوم في حياتي', 2.5),
    MoodKeyword('استثنائي', 1.5),
    MoodKeyword('فريد من نوعه', 1.5),
    MoodKeyword('رائع بحق', 2.0),
    MoodKeyword('مبهر', 1.8),
    MoodKeyword('مبهرة', 1.8),
    MoodKeyword('خيالي', 1.8),
    MoodKeyword('خيالية', 1.8),
    MoodKeyword('لا يوصف', 1.8),

    // Egyptian Arabic
    MoodKeyword('مبسوط', 1.8),
    MoodKeyword('مبسوطة', 1.8),
    MoodKeyword('مبسوط اوي', 2.5),
    MoodKeyword('مبسوطة اوي', 2.5),
    MoodKeyword('مبسوط أوي', 2.5),
    MoodKeyword('مبسوطة أوي', 2.5),
    MoodKeyword('فرحان', 1.8),
    MoodKeyword('فرحانة', 1.8),
    MoodKeyword('فرحان اوي', 2.5),
    MoodKeyword('فرحانة اوي', 2.5),
    MoodKeyword('فرحان أوي', 2.5),
    MoodKeyword('فرحانة أوي', 2.5),
    MoodKeyword('متحمس اوي', 2.5),
    MoodKeyword('متحمسة اوي', 2.5),
    MoodKeyword('متحمس أوي', 2.5),
    MoodKeyword('متحمسة أوي', 2.5),
    MoodKeyword('جامد', 1.5),
    MoodKeyword('جامدة', 1.5),
    MoodKeyword('جامد اوي', 2.0),
    MoodKeyword('جامدة اوي', 2.0),
    MoodKeyword('تحفة', 1.8),
    MoodKeyword('تحفه', 1.8),
    MoodKeyword('عظمة', 1.8),
    MoodKeyword('عظمه', 1.8),
    MoodKeyword('روعة', 1.8),
    MoodKeyword('روعه', 1.8),
    MoodKeyword('بجد تحفة', 2.0),
    MoodKeyword('بجد جامد', 1.8),
    MoodKeyword('يلا بينا', 1.8),
    MoodKeyword('يلا نبدأ', 1.8),
    MoodKeyword('مش قادر استنى', 2.0),
    MoodKeyword('مش قادرة استنى', 2.0),
    MoodKeyword('مش قادر أستنى', 2.0),
    MoodKeyword('مش قادرة أستنى', 2.0),
    MoodKeyword('الدنيا حلوة', 1.8),
    MoodKeyword('أنا طاير من الفرحة', 2.5),
    MoodKeyword('انا طاير من الفرحة', 2.5),
    MoodKeyword('أنا طايرة من الفرحة', 2.5),
    MoodKeyword('انا طايرة من الفرحة', 2.5),
    MoodKeyword('قلبي فرحان', 2.2),
    MoodKeyword('قلبي طاير', 2.2),
    MoodKeyword('مش مصدق', 1.8),
    MoodKeyword('مش مصدقة', 1.8),
    MoodKeyword('مش قادر اصدق', 1.8),
    MoodKeyword('مش قادرة اصدق', 1.8),
    MoodKeyword('يا فرحتي', 2.0),
    MoodKeyword('يا نهار أبيض', 1.5),
    MoodKeyword('يا نهار ابيض', 1.5),
    // Egyptian Arabic (expanded)
    MoodKeyword('مبسوط جدا جدا', 2.8),
    MoodKeyword('حاسس اني في السحاب', 2.3),
    MoodKeyword('حاسة اني في السحاب', 2.3),
    MoodKeyword('حاسس اني طاير', 2.2),
    MoodKeyword('حاسة اني طايرة', 2.2),
    MoodKeyword('احلى يوم', 2.0),
    MoodKeyword('احسن حاجة حصلت', 2.2),
    MoodKeyword('مش مصدق اللي حصل', 2.2),
    MoodKeyword('ده احلى حاجة', 2.0),
    MoodKeyword('ده اجمل حاجة', 2.0),
    MoodKeyword('بجد فرحان', 2.0),
    MoodKeyword('بجد فرحانة', 2.0),
    MoodKeyword('بجد مبسوط', 2.0),
    MoodKeyword('بجد مبسوطة', 2.0),
    MoodKeyword('نجحت', 1.8),
    MoodKeyword('نجحنا', 2.0),
    MoodKeyword('كسبنا', 1.8),
    MoodKeyword('فزنا', 1.8),
    MoodKeyword('حلمي اتحقق', 2.3),
    MoodKeyword('يا رب تدوم الفرحة', 1.8),

    // Arabizi
    MoodKeyword('mabsout', 1.8),
    MoodKeyword('mabsoota', 1.8),
    MoodKeyword('mabsout awy', 2.5),
    MoodKeyword('mabsoota awy', 2.5),
    MoodKeyword('farhan', 1.8),
    MoodKeyword('farhana', 1.8),
    MoodKeyword('farhan awy', 2.5),
    MoodKeyword('farhana awy', 2.5),
    MoodKeyword('mot7ames', 2.0),
    MoodKeyword('mota7ames', 2.0),
    MoodKeyword('mot7amessa', 2.0),
    MoodKeyword('gamda', 1.5),
    MoodKeyword('gamda awy', 2.0),
    MoodKeyword('ta7fa', 1.8),
    MoodKeyword('3azama', 1.8),
    MoodKeyword('3azama awy', 2.0),
    MoodKeyword('yalla bina', 1.8),
    MoodKeyword('yalla nبدأ', 1.5),
    MoodKeyword('mesh 2ader astana', 2.0),
    MoodKeyword('mesh 2adra astana', 2.0),
    MoodKeyword('ana mabsoot', 2.0),
    MoodKeyword('ana mabsoota', 2.0),
    MoodKeyword('ana farhan', 2.0),
    MoodKeyword('ana farhana', 2.0),
    MoodKeyword('el donia 7elwa', 1.8),
    // Arabizi (expanded)
    MoodKeyword('mabsoot awy awy', 2.8),
    MoodKeyword('ana fel sama', 2.2),
    MoodKeyword('ahla yom', 2.0),
    MoodKeyword('nagaht', 1.8),
    MoodKeyword('nagahna', 2.0),
    MoodKeyword('kasabna', 1.8),
    MoodKeyword('fazna', 1.8),
    MoodKeyword('helmy et7a2a2', 2.3),
  ];

  // ---------------------------------------------------------------------------
  // HAPPY
  // ---------------------------------------------------------------------------

  static const happyKeywords = <MoodKeyword>[
    // English
    MoodKeyword('happy', 1.8),
    MoodKeyword('happiness', 1.8),
    MoodKeyword('glad', 1.5),
    MoodKeyword('good', 0.8),
    MoodKeyword('nice', 1.0),
    MoodKeyword('love', 1.5),
    MoodKeyword('loved', 1.5),
    MoodKeyword('loving', 1.5),
    MoodKeyword('like', 0.8),
    MoodKeyword('enjoy', 1.2),
    MoodKeyword('enjoyed', 1.2),
    MoodKeyword('enjoying', 1.2),
    MoodKeyword('pleased', 1.5),
    MoodKeyword('delighted', 1.8),
    MoodKeyword('joy', 1.8),
    MoodKeyword('joyful', 1.8),
    MoodKeyword('smile', 1.2),
    MoodKeyword('smiling', 1.2),
    MoodKeyword('laughed', 1.2),
    MoodKeyword('laugh', 1.2),
    MoodKeyword('laughing', 1.2),
    MoodKeyword('fun', 1.0),
    MoodKeyword('funny', 1.0),
    MoodKeyword('blessed', 1.5),
    MoodKeyword('grateful', 1.5),
    MoodKeyword('thankful', 1.5),
    MoodKeyword('appreciate', 1.2),
    MoodKeyword('appreciated', 1.2),
    MoodKeyword('content', 1.2),
    MoodKeyword('satisfied', 1.2),
    MoodKeyword('cheerful', 1.5),
    MoodKeyword('positive', 1.2),
    MoodKeyword('beautiful', 1.2),
    MoodKeyword('perfect', 1.5),
    MoodKeyword('best', 1.2),
    MoodKeyword('lovely', 1.5),
    MoodKeyword('sweet', 1.0),
    MoodKeyword('kind', 0.8),
    MoodKeyword('relieved', 1.5),
    MoodKeyword('peaceful', 1.5),
    MoodKeyword('calm', 1.0),
    MoodKeyword('relaxed', 1.2),
    MoodKeyword('proud', 1.5),
    MoodKeyword('hopeful', 1.2),
    MoodKeyword('lucky', 1.2),
    MoodKeyword('fortunate', 1.2),
    MoodKeyword('safe', 1.0),
    MoodKeyword('comfortable', 1.0),
    MoodKeyword('optimistic', 1.5),
    MoodKeyword('positive vibes', 1.5),
    MoodKeyword('good vibes', 1.5),
    MoodKeyword('good mood', 1.5),
    // English (expanded)
    MoodKeyword('warm', 1.0),
    MoodKeyword('wholesome', 1.5),
    MoodKeyword('heartwarming', 1.8),
    MoodKeyword('uplifting', 1.5),
    MoodKeyword('soothing', 1.3),
    MoodKeyword('tranquil', 1.3),
    MoodKeyword('serene', 1.5),
    MoodKeyword('harmonious', 1.3),
    MoodKeyword('balanced', 1.0),
    MoodKeyword('refreshed', 1.3),
    MoodKeyword('rejuvenated', 1.5),
    MoodKeyword('radiant', 1.5),
    MoodKeyword('glowing', 1.3),
    MoodKeyword('bright', 1.0),
    MoodKeyword('sunny', 1.0),
    MoodKeyword('carefree', 1.3),
    MoodKeyword('easygoing', 1.0),
    MoodKeyword('chill', 1.0),
    MoodKeyword('mellow', 1.0),
    MoodKeyword('at ease', 1.3),
    MoodKeyword('at peace', 1.5),
    MoodKeyword('fulfilled', 1.5),
    MoodKeyword('accomplished', 1.5),
    MoodKeyword('gratified', 1.3),
    MoodKeyword('touched', 1.3),
    MoodKeyword('moved', 1.0),
    MoodKeyword('heartfelt', 1.3),
    MoodKeyword('affectionate', 1.3),
    MoodKeyword('fond', 1.0),
    MoodKeyword('cherish', 1.3),
    MoodKeyword('cherished', 1.3),
    MoodKeyword('treasure', 1.2),
    MoodKeyword('treasured', 1.3),
    MoodKeyword('cozy', 1.2),
    MoodKeyword('snug', 1.0),
    MoodKeyword('comfy', 1.0),
    MoodKeyword('homely', 1.0),
    MoodKeyword('nostalgic', 1.0),
    MoodKeyword('sentimental', 1.0),
    MoodKeyword('genuine', 0.8),
    MoodKeyword('sincere', 0.8),
    MoodKeyword('warmhearted', 1.5),
    MoodKeyword('tender', 1.0),
    MoodKeyword('gentle', 0.8),
    MoodKeyword('caring', 1.0),
    MoodKeyword('compassionate', 1.0),
    MoodKeyword('friendly', 0.8),
    MoodKeyword('welcoming', 1.0),
    MoodKeyword('hospitable', 1.0),
    MoodKeyword('generous', 0.8),
    MoodKeyword('thoughtful', 0.8),
    MoodKeyword('considerate', 0.8),

    // English phrases
    MoodKeyword('feeling good', 1.5),
    MoodKeyword('feeling great', 1.8),
    MoodKeyword('feeling amazing', 2.0),
    MoodKeyword('feeling happy', 2.0),
    MoodKeyword('in a good mood', 1.8),
    MoodKeyword('in a great mood', 2.0),
    MoodKeyword('made my day', 1.8),
    MoodKeyword('you made my day', 2.0),
    MoodKeyword('having a good day', 1.8),
    MoodKeyword('having a great day', 2.0),
    MoodKeyword('everything is fine', 1.2),
    MoodKeyword('everything is good', 1.5),
    MoodKeyword('life is good', 1.8),
    MoodKeyword('life is beautiful', 1.8),
    MoodKeyword('i feel good', 1.5),
    MoodKeyword("i'm good", 1.2),
    MoodKeyword('i am good', 1.2),
    MoodKeyword('i feel great', 1.8),
    MoodKeyword("i'm feeling great", 1.8),
    MoodKeyword('so grateful', 1.8),
    MoodKeyword('very grateful', 1.8),
    MoodKeyword('so thankful', 1.8),
    MoodKeyword('thank god', 1.5),
    MoodKeyword('thank goodness', 1.5),
    MoodKeyword('all good', 1.2),
    MoodKeyword('no worries', 1.2),
    MoodKeyword('feels good', 1.5),
    MoodKeyword('feels great', 1.8),

    // Arabic
    MoodKeyword('سعيد', 1.5),
    MoodKeyword('سعيدة', 1.5),
    MoodKeyword('سعادة', 1.8),
    MoodKeyword('فرحان', 1.5),
    MoodKeyword('فرحانة', 1.5),
    MoodKeyword('فرح', 1.2),
    MoodKeyword('فرحان جدا', 2.0),
    MoodKeyword('فرحانة جدا', 2.0),
    MoodKeyword('مبسوط', 1.5),
    MoodKeyword('مبسوطة', 1.5),
    MoodKeyword('مسرور', 1.5),
    MoodKeyword('مسرورة', 1.5),
    MoodKeyword('مبهج', 1.5),
    MoodKeyword('مبهجة', 1.5),
    MoodKeyword('ممتن', 1.5),
    MoodKeyword('ممتنة', 1.5),
    MoodKeyword('امتنان', 1.5),
    MoodKeyword('شكرا', 0.8),
    MoodKeyword('شكراً', 0.8),
    MoodKeyword('أحب', 1.5),
    MoodKeyword('احب', 1.5),
    MoodKeyword('بحب', 1.5),
    MoodKeyword('استمتع', 1.2),
    MoodKeyword('مطمئن', 1.5),
    MoodKeyword('مطمئنة', 1.5),
    MoodKeyword('مرتاح', 1.5),
    MoodKeyword('مرتاحة', 1.5),
    MoodKeyword('راضي', 1.2),
    MoodKeyword('راضية', 1.2),
    MoodKeyword('فخور', 1.5),
    MoodKeyword('فخورة', 1.5),
    MoodKeyword('متفائل', 1.5),
    MoodKeyword('متفائلة', 1.5),
    MoodKeyword('الحمد لله', 1.5),
    MoodKeyword('الحمدلله', 1.5),
    MoodKeyword('ربنا كريم', 1.2),
    MoodKeyword('الدنيا حلوة', 1.5),
    MoodKeyword('أنا تمام', 1.2),
    MoodKeyword('انا تمام', 1.2),
    MoodKeyword('كويس', 1.0),
    MoodKeyword('كويسة', 1.0),
    MoodKeyword('تمام', 0.8),
    MoodKeyword('زي الفل', 1.8),
    MoodKeyword('تمام التمام', 1.8),
    MoodKeyword('مبسوط اوي', 2.0),
    MoodKeyword('مبسوطة اوي', 2.0),
    MoodKeyword('قلبي فرحان', 2.0),
    MoodKeyword('قلبي مرتاح', 1.8),
    MoodKeyword('كل حاجة تمام', 1.8),
    MoodKeyword('كل حاجه تمام', 1.8),
    MoodKeyword('الدنيا تمام', 1.5),
    MoodKeyword('أنا بخير', 1.5),
    MoodKeyword('انا بخير', 1.5),
    // Arabic (expanded)
    MoodKeyword('دفء', 1.2),
    MoodKeyword('طمأنينة', 1.5),
    MoodKeyword('سكينة', 1.5),
    MoodKeyword('هدوء', 1.0),
    MoodKeyword('انسجام', 1.2),
    MoodKeyword('توازن', 1.0),
    MoodKeyword('منتعش', 1.2),
    MoodKeyword('مشرق', 1.2),
    MoodKeyword('مرح', 1.2),
    MoodKeyword('بهيج', 1.3),
    MoodKeyword('وديع', 1.0),
    MoodKeyword('حنون', 1.0),
    MoodKeyword('رقيق', 0.8),
    MoodKeyword('كريم', 0.8),
    MoodKeyword('مضياف', 1.0),
    MoodKeyword('صادق', 0.8),
    MoodKeyword('مرتاح البال', 1.8),
    MoodKeyword('قرير العين', 1.5),

    // Arabizi
    MoodKeyword('sa3eed', 1.5),
    MoodKeyword('sa3eeda', 1.5),
    MoodKeyword('far7an', 1.5),
    MoodKeyword('far7ana', 1.5),
    MoodKeyword('mabsout', 1.5),
    MoodKeyword('mabsoota', 1.5),
    MoodKeyword('merta7', 1.5),
    MoodKeyword('merta7a', 1.5),
    MoodKeyword('ana tamam', 1.2),
    MoodKeyword('ana kwayes', 1.2),
    MoodKeyword('ana kwayesa', 1.2),
    MoodKeyword('kwayes', 1.0),
    MoodKeyword('kwayesa', 1.0),
    MoodKeyword('zay el fol', 1.8),
    MoodKeyword('el 7amdulillah', 1.5),
    MoodKeyword('el donia 7elwa', 1.5),
    MoodKeyword('alhamdulillah', 1.5),
    MoodKeyword('al7amdulillah', 1.5),
    MoodKeyword('kol 7aga tamam', 1.8),
    // Arabizi (expanded)
    MoodKeyword('albi hadi', 1.8),
    MoodKeyword('merta7 albi', 1.8),
    MoodKeyword('bagad sa3eed', 1.8),
    MoodKeyword('bagad sa3eeda', 1.8),
    MoodKeyword('el gaw 7elw', 1.3),
    MoodKeyword('yom 7elw', 1.5),
    MoodKeyword('7ayah 7elwa', 1.5),
  ];

  // ---------------------------------------------------------------------------
  // SAD
  // ---------------------------------------------------------------------------

  static const sadKeywords = <MoodKeyword>[
    // English
    MoodKeyword('sad', 1.8),
    MoodKeyword('sadness', 2.0),
    MoodKeyword('unhappy', 1.8),
    MoodKeyword('depressed', 2.5),
    MoodKeyword('depressing', 2.0),
    MoodKeyword('down', 1.2),
    MoodKeyword('blue', 1.2),
    MoodKeyword('cry', 1.8),
    MoodKeyword('crying', 2.0),
    MoodKeyword('cried', 1.8),
    MoodKeyword('tears', 1.8),
    MoodKeyword('tearful', 1.8),
    MoodKeyword('miss', 1.2),
    MoodKeyword('missing', 1.5),
    MoodKeyword('lonely', 2.0),
    MoodKeyword('loneliness', 2.0),
    MoodKeyword('alone', 1.5),
    MoodKeyword('heartbroken', 2.5),
    MoodKeyword('heartbreak', 2.5),
    MoodKeyword('hurt', 1.8),
    MoodKeyword('hurting', 1.8),
    MoodKeyword('pain', 1.8),
    MoodKeyword('painful', 1.8),
    MoodKeyword('sorrow', 2.0),
    MoodKeyword('grief', 2.5),
    MoodKeyword('grieving', 2.5),
    MoodKeyword('mourn', 2.5),
    MoodKeyword('mourning', 2.5),
    MoodKeyword('disappointed', 1.8),
    MoodKeyword('disappointment', 1.8),
    MoodKeyword('regret', 1.5),
    MoodKeyword('regretful', 1.5),
    MoodKeyword('sorry', 0.8),
    MoodKeyword('unfortunate', 1.2),
    MoodKeyword('miserable', 2.2),
    MoodKeyword('gloomy', 1.8),
    MoodKeyword('hopeless', 2.2),
    MoodKeyword('helpless', 2.0),
    MoodKeyword('empty', 2.0),
    MoodKeyword('emptiness', 2.0),
    MoodKeyword('lost', 1.2),
    MoodKeyword('broken', 2.2),
    MoodKeyword('tired', 1.0),
    MoodKeyword('exhausted', 1.5),
    MoodKeyword('drained', 1.5),
    MoodKeyword('devastated', 2.5),
    MoodKeyword('melancholy', 2.0),
    MoodKeyword('low', 1.2),
    MoodKeyword('weak', 1.0),
    MoodKeyword('worthless', 2.2),
    MoodKeyword('failure', 1.8),
    MoodKeyword('failed', 1.5),
    MoodKeyword('rejected', 2.0),
    MoodKeyword('rejection', 2.0),
    MoodKeyword('betrayed', 2.2),
    MoodKeyword('betrayal', 2.2),
    MoodKeyword('ignored', 1.8),
    MoodKeyword('forgotten', 1.8),
    MoodKeyword('abandoned', 2.2),
    MoodKeyword('abandonment', 2.2),
    // English (expanded)
    MoodKeyword('somber', 1.8),
    MoodKeyword('sorrowful', 2.0),
    MoodKeyword('despondent', 2.2),
    MoodKeyword('dejected', 2.0),
    MoodKeyword('downcast', 1.8),
    MoodKeyword('crestfallen', 2.0),
    MoodKeyword('forlorn', 2.0),
    MoodKeyword('woeful', 1.8),
    MoodKeyword('bereft', 2.2),
    MoodKeyword('heavyhearted', 2.0),
    MoodKeyword('downhearted', 1.8),
    MoodKeyword('weeping', 2.2),
    MoodKeyword('sobbing', 2.2),
    MoodKeyword('sniffling', 1.5),
    MoodKeyword('choked up', 1.8),
    MoodKeyword('aching', 1.5),
    MoodKeyword('ache', 1.3),
    MoodKeyword('longing', 1.5),
    MoodKeyword('yearning', 1.5),
    MoodKeyword('homesick', 1.8),
    MoodKeyword('discouraged', 1.8),
    MoodKeyword('demoralized', 2.0),
    MoodKeyword('defeated', 2.0),
    MoodKeyword('crushed', 2.0),
    MoodKeyword('shattered', 2.2),
    MoodKeyword('wrecked', 2.0),
    MoodKeyword('numb', 1.8),
    MoodKeyword('hollow', 1.8),
    MoodKeyword('void', 1.5),
    MoodKeyword('desolate', 2.0),
    MoodKeyword('bleak', 1.8),
    MoodKeyword('dismal', 1.8),
    MoodKeyword('inconsolable', 2.5),
    MoodKeyword('anguished', 2.3),
    MoodKeyword('anguish', 2.3),
    MoodKeyword('despair', 2.3),
    MoodKeyword('despairing', 2.3),
    MoodKeyword('wretched', 2.0),
    MoodKeyword('pitiful', 1.5),
    MoodKeyword('sullen', 1.5),
    MoodKeyword('moody', 1.2),
    MoodKeyword('brooding', 1.5),
    MoodKeyword('withdrawn', 1.5),
    MoodKeyword('isolated', 1.8),
    MoodKeyword('isolation', 1.8),
    MoodKeyword('estranged', 1.8),
    MoodKeyword('unloved', 2.0),
    MoodKeyword('unwanted', 2.0),
    MoodKeyword('neglected', 2.0),
    MoodKeyword('neglect', 1.8),
    MoodKeyword('overlooked', 1.5),
    MoodKeyword('dismissed', 1.5),
    MoodKeyword('let down', 1.8),
    MoodKeyword('gave up', 2.0),
    MoodKeyword('giving up', 2.0),
    MoodKeyword('no point', 2.0),

    // English phrases
    MoodKeyword('i feel awful', 2.0),
    MoodKeyword('i feel terrible', 2.0),
    MoodKeyword('i feel bad', 1.5),
    MoodKeyword('i feel sad', 2.0),
    MoodKeyword('i am sad', 2.0),
    MoodKeyword("i'm sad", 2.0),
    MoodKeyword('i feel lonely', 2.2),
    MoodKeyword('i feel alone', 2.2),
    MoodKeyword('i feel empty', 2.2),
    MoodKeyword('i feel lost', 1.8),
    MoodKeyword('i feel broken', 2.2),
    MoodKeyword('not okay', 2.0),
    MoodKeyword('not ok', 2.0),
    MoodKeyword('nothing matters', 2.5),
    MoodKeyword('everything hurts', 2.2),
    MoodKeyword('life hurts', 2.0),
    MoodKeyword('i miss you', 2.0),
    MoodKeyword('i miss them', 1.8),
    MoodKeyword('i miss him', 1.8),
    MoodKeyword('i miss her', 1.8),
    MoodKeyword('i cannot stop crying', 2.5),
    MoodKeyword("i can't stop crying", 2.5),
    MoodKeyword('cant stop crying', 2.5),
    MoodKeyword('having a bad day', 1.8),
    MoodKeyword('bad day', 1.5),
    MoodKeyword('worst day', 2.0),
    MoodKeyword('hard day', 1.5),
    MoodKeyword('rough day', 1.5),
    MoodKeyword('i give up', 2.2),
    MoodKeyword('i feel hopeless', 2.2),
    MoodKeyword('i feel helpless', 2.0),
    MoodKeyword('nobody cares', 2.2),
    MoodKeyword('no one cares', 2.2),
    MoodKeyword('i am alone', 1.8),
    MoodKeyword("i'm alone", 1.8),
    // English phrases (expanded)
    MoodKeyword('can not go on', 2.3),
    MoodKeyword("can't go on", 2.3),
    MoodKeyword('nothing left', 2.2),

    // Arabic
    MoodKeyword('حزين', 1.8),
    MoodKeyword('حزينة', 1.8),
    MoodKeyword('حزن', 1.8),
    MoodKeyword('زعلان', 1.8),
    MoodKeyword('زعلانة', 1.8),
    MoodKeyword('مضايق', 1.5),
    MoodKeyword('مضايقة', 1.5),
    MoodKeyword('مكتئب', 2.5),
    MoodKeyword('مكتئبة', 2.5),
    MoodKeyword('اكتئاب', 2.5),
    MoodKeyword('كئيب', 2.0),
    MoodKeyword('كئيبة', 2.0),
    MoodKeyword('وحيد', 2.0),
    MoodKeyword('وحيدة', 2.0),
    MoodKeyword('وحدة', 2.0),
    MoodKeyword('لوحدي', 1.8),
    MoodKeyword('حاسة بالوحدة', 2.2),
    MoodKeyword('حاسس بالوحدة', 2.2),
    MoodKeyword('بعيط', 2.0),
    MoodKeyword('ببكي', 2.0),
    MoodKeyword('بكى', 1.8),
    MoodKeyword('بكاء', 1.8),
    MoodKeyword('دموعي', 1.8),
    MoodKeyword('دموع', 1.5),
    MoodKeyword('مكسور', 2.2),
    MoodKeyword('مكسورة', 2.2),
    MoodKeyword('قلبي مكسور', 2.5),
    MoodKeyword('متألم', 2.0),
    MoodKeyword('متألمة', 2.0),
    MoodKeyword('ألم', 1.8),
    MoodKeyword('الم', 1.8),
    MoodKeyword('وجع', 1.8),
    MoodKeyword('موجوع', 2.0),
    MoodKeyword('موجوعة', 2.0),
    MoodKeyword('مشتاق', 1.5),
    MoodKeyword('مشتاقة', 1.5),
    MoodKeyword('اشتياق', 1.8),
    MoodKeyword('وحشتني', 1.8),
    MoodKeyword('وحشتيني', 1.8),
    MoodKeyword('وحشتني اوي', 2.2),
    MoodKeyword('وحشتيني اوي', 2.2),
    MoodKeyword('محبط', 1.8),
    MoodKeyword('محبطة', 1.8),
    MoodKeyword('إحباط', 1.8),
    MoodKeyword('احباط', 1.8),
    MoodKeyword('يائس', 2.2),
    MoodKeyword('يائسة', 2.2),
    MoodKeyword('يأس', 2.2),
    MoodKeyword('فاقد الأمل', 2.2),
    MoodKeyword('فاقدة الأمل', 2.2),
    MoodKeyword('فقدت الأمل', 2.2),
    MoodKeyword('تعبان', 1.2),
    MoodKeyword('تعبانة', 1.2),
    MoodKeyword('تعب', 1.2),
    MoodKeyword('مرهق', 1.5),
    MoodKeyword('مرهقة', 1.5),
    MoodKeyword('منهك', 1.5),
    MoodKeyword('منهكة', 1.5),
    MoodKeyword('مخنوق', 1.8),
    MoodKeyword('مخنوقة', 1.8),
    MoodKeyword('مش كويس', 1.8),
    MoodKeyword('مش كويسة', 1.8),
    MoodKeyword('مش تمام', 1.8),
    MoodKeyword('أنا تعبان', 1.5),
    MoodKeyword('انا تعبان', 1.5),
    MoodKeyword('أنا تعبانة', 1.5),
    MoodKeyword('انا تعبانة', 1.5),
    MoodKeyword('مش قادر أكمل', 2.5),
    MoodKeyword('مش قادرة أكمل', 2.5),
    MoodKeyword('مش قادر اكمل', 2.5),
    MoodKeyword('مش قادرة اكمل', 2.5),
    MoodKeyword('مش قادر', 1.5),
    MoodKeyword('مش قادرة', 1.5),
    MoodKeyword('مش عايز', 1.0),
    MoodKeyword('مش عايزة', 1.0),
    MoodKeyword('مفيش فايدة', 2.0),
    MoodKeyword('مفيش أمل', 2.2),
    MoodKeyword('مفيش امل', 2.2),
    MoodKeyword('محدش فاهمني', 2.0),
    MoodKeyword('محدش حاسس بيا', 2.2),
    MoodKeyword('حاسس إني لوحدي', 2.2),
    MoodKeyword('حاسة إني لوحدي', 2.2),
    MoodKeyword('حاسس اني لوحدي', 2.2),
    MoodKeyword('حاسة اني لوحدي', 2.2),
    // Arabic (expanded)
    MoodKeyword('كآبة', 2.2),
    MoodKeyword('أسى', 1.8),
    MoodKeyword('أسف', 1.2),
    MoodKeyword('مغموم', 2.0),
    MoodKeyword('مغمومة', 2.0),
    MoodKeyword('كسير القلب', 2.5),
    MoodKeyword('منكسر', 2.0),
    MoodKeyword('منكسرة', 2.0),
    MoodKeyword('موجع القلب', 2.2),
    MoodKeyword('حزن عميق', 2.3),
    MoodKeyword('حزن شديد', 2.3),
    MoodKeyword('وحشة', 1.8),
    MoodKeyword('غربة', 1.5),
    MoodKeyword('انكسار', 2.0),
    MoodKeyword('خذلان', 2.0),
    MoodKeyword('خيبة أمل', 1.8),
    MoodKeyword('قنوط', 2.2),
    MoodKeyword('بائس', 2.0),
    MoodKeyword('بائسة', 2.0),
    MoodKeyword('منعزل', 1.8),
    MoodKeyword('منعزلة', 1.8),
    MoodKeyword('مهمل', 1.8),
    MoodKeyword('مهملة', 1.8),
    MoodKeyword('منسي', 1.8),
    MoodKeyword('منسية', 1.8),

    // Egyptian additions
    MoodKeyword('قلبي واجعني', 2.2),
    MoodKeyword('حاسس بخيبة أمل', 1.8),
    MoodKeyword('حاسة بخيبة أمل', 1.8),
    MoodKeyword('محدش بيسأل عني', 2.0),
    MoodKeyword('مفيش حد جنبي', 2.0),
    MoodKeyword('تعبت نفسيا', 1.8),
    MoodKeyword('تعبت جوايا', 2.0),
    MoodKeyword('مش لاقي حد يفهمني', 2.0),
    MoodKeyword('مش لاقية حد يفهمني', 2.0),
    MoodKeyword('ضاعت مني', 1.8),
    MoodKeyword('ضاع مني كل حاجة', 2.2),

    // Arabizi
    MoodKeyword('7azeen', 1.8),
    MoodKeyword('7azeena', 1.8),
    MoodKeyword('7ozn', 1.8),
    MoodKeyword('za3lan', 1.8),
    MoodKeyword('za3lana', 1.8),
    MoodKeyword('wa7eed', 2.0),
    MoodKeyword('wa7eeda', 2.0),
    MoodKeyword('wa7da', 1.8),
    MoodKeyword('ba3ayet', 2.0),
    MoodKeyword('b3ayet', 2.0),
    MoodKeyword('b2y', 1.8),
    MoodKeyword('meksour', 2.0),
    MoodKeyword('meksoura', 2.0),
    MoodKeyword('merta7', 1.0),
    MoodKeyword('wa7ashteny', 1.8),
    MoodKeyword('wa7ashtini', 1.8),
    MoodKeyword('ta3ban', 1.5),
    MoodKeyword('ta3bana', 1.5),
    MoodKeyword('mesh tamam', 1.8),
    MoodKeyword('mfeesh fayda', 2.0),
    MoodKeyword('mfeesh amal', 2.2),
    MoodKeyword('ana ta3ban', 1.8),
    MoodKeyword('ana ta3bana', 1.8),
    MoodKeyword('ana wa7dy', 2.0),
    MoodKeyword('ana wa7da', 2.0),
    // Arabizi (expanded)
    MoodKeyword('5ayba amal', 1.8),
    MoodKeyword('ma7dsh bysal 3any', 2.0),
    MoodKeyword('mafeesh 7ad ganby', 2.0),
    MoodKeyword('ta3bet nafseyan', 1.8),
  ];

  // ---------------------------------------------------------------------------
  // ANGRY
  // ---------------------------------------------------------------------------

  static const angryKeywords = <MoodKeyword>[
    // English
    MoodKeyword('angry', 2.0),
    MoodKeyword('anger', 2.0),
    MoodKeyword('mad', 1.5),
    MoodKeyword('furious', 2.5),
    MoodKeyword('fury', 2.5),
    MoodKeyword('rage', 2.5),
    MoodKeyword('raging', 2.5),
    MoodKeyword('hateful', 2.0),
    MoodKeyword('hate', 1.8),
    MoodKeyword('hating', 1.8),
    MoodKeyword('annoyed', 1.8),
    MoodKeyword('annoying', 1.5),
    MoodKeyword('irritated', 1.8),
    MoodKeyword('irritating', 1.5),
    MoodKeyword('frustrated', 1.8),
    MoodKeyword('frustrating', 1.5),
    MoodKeyword('upset', 1.5),
    MoodKeyword('outraged', 2.2),
    MoodKeyword('infuriated', 2.5),
    MoodKeyword('livid', 2.5),
    MoodKeyword('disgusted', 2.0),
    MoodKeyword('disgusting', 1.8),
    MoodKeyword('horrible', 1.5),
    MoodKeyword('terrible', 1.5),
    MoodKeyword('awful', 1.5),
    MoodKeyword('stupid', 1.5),
    MoodKeyword('idiot', 1.8),
    MoodKeyword('idiotic', 1.8),
    MoodKeyword('dumb', 1.5),
    MoodKeyword('ridiculous', 1.8),
    MoodKeyword('absurd', 1.5),
    MoodKeyword('pathetic', 1.8),
    MoodKeyword('worst', 1.5),
    MoodKeyword('despise', 2.0),
    MoodKeyword('loathe', 2.0),
    MoodKeyword('sick of', 1.8),
    MoodKeyword('fed up', 2.0),
    MoodKeyword("can't stand", 2.0),
    MoodKeyword('cant stand', 2.0),
    MoodKeyword('enough', 1.2),
    MoodKeyword('seriously', 0.8),
    MoodKeyword('unacceptable', 2.0),
    MoodKeyword('unfair', 1.8),
    MoodKeyword('disrespectful', 1.8),
    MoodKeyword('disrespect', 1.8),
    MoodKeyword('nonsense', 1.5),
    MoodKeyword('bullshit', 2.0),
    MoodKeyword('damn', 1.0),
    MoodKeyword('wtf', 1.8),
    MoodKeyword('ugh', 1.5),
    // English (expanded)
    MoodKeyword('enraged', 2.5),
    MoodKeyword('incensed', 2.3),
    MoodKeyword('seething', 2.3),
    MoodKeyword('boiling', 2.0),
    MoodKeyword('fuming', 2.2),
    MoodKeyword('irate', 2.2),
    MoodKeyword('wrathful', 2.3),
    MoodKeyword('indignant', 1.8),
    MoodKeyword('resentful', 1.8),
    MoodKeyword('resentment', 1.8),
    MoodKeyword('bitter', 1.5),
    MoodKeyword('bitterness', 1.5),
    MoodKeyword('hostile', 1.8),
    MoodKeyword('hostility', 1.8),
    MoodKeyword('aggressive', 1.5),
    MoodKeyword('aggravated', 1.8),
    MoodKeyword('aggravating', 1.5),
    MoodKeyword('exasperated', 1.8),
    MoodKeyword('exasperating', 1.5),
    MoodKeyword('provoked', 1.5),
    MoodKeyword('triggered', 1.8),
    MoodKeyword('raging mad', 2.5),
    MoodKeyword('boiling mad', 2.5),
    MoodKeyword('spitting mad', 2.5),
    MoodKeyword('pissed', 2.0),
    MoodKeyword('pissed off', 2.2),
    MoodKeyword('ticked off', 1.8),
    MoodKeyword('cheesed off', 1.8),
    MoodKeyword('hacked off', 1.8),
    MoodKeyword('grinding my teeth', 1.8),
    MoodKeyword('my blood is boiling', 2.3),
    MoodKeyword('sick and tired', 2.0),
    MoodKeyword('had it up to here', 2.0),
    MoodKeyword('crossed a line', 1.8),
    MoodKeyword('crossed the line', 1.8),
    MoodKeyword('out of line', 1.5),
    MoodKeyword('not cool', 1.3),
    MoodKeyword('not fair', 1.8),
    MoodKeyword('so unfair', 2.0),
    MoodKeyword('this is bull', 1.8),
    MoodKeyword('this is trash', 1.8),
    MoodKeyword('garbage', 1.5),
    MoodKeyword('back off', 1.5),
    MoodKeyword('knock it off', 1.5),
    MoodKeyword('cut it out', 1.5),

    // Arabic
    MoodKeyword('غاضب', 2.0),
    MoodKeyword('غاضبة', 2.0),
    MoodKeyword('غضب', 2.0),
    MoodKeyword('عصبي', 1.8),
    MoodKeyword('عصبية', 1.8),
    MoodKeyword('متعصب', 1.8),
    MoodKeyword('متعصبة', 1.8),
    MoodKeyword('منفعل', 1.8),
    MoodKeyword('منفعلة', 1.8),
    MoodKeyword('منزعج', 1.8),
    MoodKeyword('منزعجة', 1.8),
    MoodKeyword('متضايق', 1.8),
    MoodKeyword('متضايقة', 1.8),
    MoodKeyword('مستفز', 1.8),
    MoodKeyword('مستفزة', 1.8),
    MoodKeyword('مستاء', 1.8),
    MoodKeyword('مستاءة', 1.8),
    MoodKeyword('زهقان', 1.2),
    MoodKeyword('زهقانة', 1.2),
    MoodKeyword('زهق', 1.2),
    MoodKeyword('مخنوق', 1.5),
    MoodKeyword('مخنوقة', 1.5),
    MoodKeyword('كره', 1.8),
    MoodKeyword('بكره', 1.8),
    MoodKeyword('بكرهه', 1.8),
    MoodKeyword('بكرهها', 1.8),
    MoodKeyword('عصبية جدا', 2.3),
    MoodKeyword('عصبيه جدا', 2.3),
    MoodKeyword('عصبية أوي', 2.3),
    MoodKeyword('عصبيه أوي', 2.3),
    MoodKeyword('مش طايق', 2.0),
    MoodKeyword('مش طايقة', 2.0),
    MoodKeyword('مش مستحمل', 2.0),
    MoodKeyword('مش مستحملة', 2.0),
    MoodKeyword('كفاية', 1.5),
    MoodKeyword('بطل بقى', 1.5),
    MoodKeyword('سيبني لوحدي', 1.8),
    MoodKeyword('ابعد عني', 1.8),
    MoodKeyword('إيه القرف ده', 2.2),
    MoodKeyword('ايه القرف ده', 2.2),
    MoodKeyword('ده شيء مقرف', 2.0),
    MoodKeyword('مش مقبول', 1.8),
    MoodKeyword('غير مقبول', 1.8),
    MoodKeyword('بجد كفاية', 1.8),
    MoodKeyword('أنا اتخنقت', 1.8),
    MoodKeyword('انا اتخنقت', 1.8),
    MoodKeyword('اتخنقت', 1.8),
    MoodKeyword('حرام عليك', 1.8),
    MoodKeyword('انت مستفز', 2.0),
    MoodKeyword('انتي مستفزة', 2.0),
    MoodKeyword('مش ناقصة', 1.5),
    MoodKeyword('مش ناقص', 1.5),
    MoodKeyword('مش ناقصاك', 1.8),
    MoodKeyword('مش ناقصاكي', 1.8),
    MoodKeyword('كفاية بقى', 1.8),
    MoodKeyword('سيبني', 1.5),
    MoodKeyword('ابعد', 1.2),
    // Arabic (expanded)
    MoodKeyword('سخط', 2.0),
    MoodKeyword('استياء', 1.8),
    MoodKeyword('حنق', 2.0),
    MoodKeyword('حقد', 2.2),
    MoodKeyword('ضغينة', 2.2),
    MoodKeyword('عدائية', 1.8),
    MoodKeyword('عدواني', 1.8),
    MoodKeyword('عدوانية', 1.8),
    MoodKeyword('متذمر', 1.5),
    MoodKeyword('متذمرة', 1.5),
    MoodKeyword('ثائر', 1.8),
    MoodKeyword('ثائرة', 1.8),
    MoodKeyword('محتد', 1.8),
    MoodKeyword('محتدة', 1.8),
    MoodKeyword('يغلي غضبا', 2.3),
    MoodKeyword('دمي يغلي', 2.3),
    MoodKeyword('طفح الكيل', 2.2),
    MoodKeyword('انتهت طاقتي', 2.0),

    // Egyptian additions
    MoodKeyword('دمي بيغلي', 2.2),
    MoodKeyword('طفح الكيل بجد', 2.3),
    MoodKeyword('خلاص كفاية كده', 2.0),
    MoodKeyword('مش هسكت', 1.8),
    MoodKeyword('حاسس بغل', 2.0),
    MoodKeyword('حاسة بغل', 2.0),
    MoodKeyword('اتنرفزت', 2.0),
    MoodKeyword('نرفزني', 2.0),
    MoodKeyword('نرفزتني', 2.0),
    MoodKeyword('اتنرفزت اوي', 2.4),

    // Arabizi
    MoodKeyword('3asban', 1.8),
    MoodKeyword('3asbana', 1.8),
    MoodKeyword('3asaby', 1.8),
    MoodKeyword('mdaye2', 1.8),
    MoodKeyword('mdaye2a', 1.8),
    MoodKeyword('metdaye2', 1.8),
    MoodKeyword('metdaye2a', 1.8),
    MoodKeyword('mesh tay2', 2.0),
    MoodKeyword('mesh tay2a', 2.0),
    MoodKeyword('mesh mesta7mel', 2.0),
    MoodKeyword('mesh mesta7mela', 2.0),
    MoodKeyword('kefaya', 1.5),
    MoodKeyword('seebny lwa7dy', 1.8),
    MoodKeyword('eb3ad 3any', 1.8),
    MoodKeyword('et5ana2t', 1.8),
    MoodKeyword('et5ana2', 1.8),
    MoodKeyword('ana 3asban', 2.0),
    MoodKeyword('ana 3asbana', 2.0),
    MoodKeyword('ana mdaye2', 2.0),
    MoodKeyword('ana mdaye2a', 2.0),
    MoodKeyword('kefaya ba2a', 1.8),
    MoodKeyword('seebny', 1.5),
    // Arabizi (expanded)
    MoodKeyword('demy bygheli', 2.2),
    MoodKeyword('khalas kefaya kda', 2.0),
    MoodKeyword('etnarfezt', 2.0),
    MoodKeyword('narfezny', 2.0),
  ];

  // ---------------------------------------------------------------------------
  // ANXIOUS
  // ---------------------------------------------------------------------------

  static const anxiousKeywords = <MoodKeyword>[
    // English
    MoodKeyword('anxious', 2.0),
    MoodKeyword('anxiety', 2.0),
    MoodKeyword('nervous', 1.8),
    MoodKeyword('nervousness', 1.8),
    MoodKeyword('scared', 1.8),
    MoodKeyword('afraid', 1.8),
    MoodKeyword('fear', 1.8),
    MoodKeyword('fearful', 1.8),
    MoodKeyword('worried', 1.8),
    MoodKeyword('worry', 1.5),
    MoodKeyword('worrying', 1.8),
    MoodKeyword('stress', 1.5),
    MoodKeyword('stressed', 1.8),
    MoodKeyword('stressful', 1.5),
    MoodKeyword('panic', 2.5),
    MoodKeyword('panicking', 2.5),
    MoodKeyword('panic attack', 2.8),
    MoodKeyword('overwhelmed', 2.0),
    MoodKeyword('uncertain', 1.2),
    MoodKeyword('unsure', 1.2),
    MoodKeyword('doubt', 1.2),
    MoodKeyword('doubtful', 1.2),
    MoodKeyword('terrified', 2.5),
    MoodKeyword('terrifying', 2.2),
    MoodKeyword('horrified', 2.2),
    MoodKeyword('horror', 1.8),
    MoodKeyword('dread', 2.0),
    MoodKeyword('dreading', 2.0),
    MoodKeyword('uneasy', 1.8),
    MoodKeyword('tense', 1.5),
    MoodKeyword('restless', 1.5),
    MoodKeyword('uncomfortable', 1.2),
    MoodKeyword('awkward', 1.0),
    MoodKeyword('paranoid', 2.2),
    MoodKeyword('insecure', 1.8),
    MoodKeyword('confused', 1.0),
    MoodKeyword('desperate', 1.8),
    MoodKeyword('helpless', 1.8),
    MoodKeyword('hopeless', 1.8),
    MoodKeyword('pressured', 1.8),
    MoodKeyword('pressure', 1.5),
    MoodKeyword('overthinking', 2.0),
    MoodKeyword('overthink', 1.8),
    MoodKeyword('shaking', 1.8),
    MoodKeyword('shaky', 1.8),
    MoodKeyword('scary', 1.8),
    MoodKeyword('worst case', 1.5),
    MoodKeyword('unclear', 1.0),
    // English (expanded)
    MoodKeyword('apprehensive', 1.8),
    MoodKeyword('apprehension', 1.8),
    MoodKeyword('jittery', 1.8),
    MoodKeyword('jumpy', 1.8),
    MoodKeyword('on edge', 2.0),
    MoodKeyword('edgy', 1.5),
    MoodKeyword('skittish', 1.5),
    MoodKeyword('rattled', 1.8),
    MoodKeyword('shaken', 1.8),
    MoodKeyword('shook', 1.5),
    MoodKeyword('spooked', 1.8),
    MoodKeyword('alarmed', 1.8),
    MoodKeyword('alarming', 1.5),
    MoodKeyword('distressed', 2.0),
    MoodKeyword('distressing', 1.8),
    MoodKeyword('troubled', 1.5),
    MoodKeyword('troubling', 1.5),
    MoodKeyword('agitated', 1.8),
    MoodKeyword('agitation', 1.8),
    MoodKeyword('flustered', 1.5),
    MoodKeyword('frazzled', 1.8),
    MoodKeyword('strung out', 2.0),
    MoodKeyword('wound up', 1.5),
    MoodKeyword('keyed up', 1.5),
    MoodKeyword('butterflies', 1.5),
    MoodKeyword('butterflies in my stomach', 1.8),
    MoodKeyword('knot in my stomach', 2.0),
    MoodKeyword('stomach in knots', 2.0),
    MoodKeyword('sweaty palms', 1.8),
    MoodKeyword('cold sweat', 1.8),
    MoodKeyword('lump in my throat', 1.8),
    MoodKeyword('racing thoughts', 2.0),
    MoodKeyword('spiraling', 2.0),
    MoodKeyword('spiral', 1.5),
    MoodKeyword('catastrophizing', 2.0),
    MoodKeyword('worst case scenario', 1.8),
    MoodKeyword('second guessing', 1.5),
    MoodKeyword('second-guessing', 1.5),
    MoodKeyword('insomnia', 1.8),
    MoodKeyword("can't sleep", 1.8),
    MoodKeyword('cant sleep', 1.8),
    MoodKeyword('sleepless', 1.5),
    MoodKeyword('restless night', 1.5),
    MoodKeyword('walking on eggshells', 2.0),
    MoodKeyword('on high alert', 1.8),
    MoodKeyword('hypervigilant', 2.0),
    MoodKeyword('claustrophobic', 1.8),
    MoodKeyword('suffocating', 2.2),
    MoodKeyword('trapped', 1.8),
    MoodKeyword('cornered', 1.5),

    // English phrases
    MoodKeyword('under pressure', 1.8),
    MoodKeyword('i am scared', 2.0),
    MoodKeyword("i'm scared", 2.0),
    MoodKeyword('i am worried', 2.0),
    MoodKeyword("i'm worried", 2.0),
    MoodKeyword('i feel anxious', 2.2),
    MoodKeyword('i feel nervous', 2.0),
    MoodKeyword('i feel scared', 2.0),
    MoodKeyword('i feel unsafe', 2.2),
    MoodKeyword('i feel uncomfortable', 1.5),
    MoodKeyword('i cannot relax', 2.0),
    MoodKeyword("i can't relax", 2.0),
    MoodKeyword('i cant relax', 2.0),
    MoodKeyword('i cannot breathe', 2.5),
    MoodKeyword("i can't breathe", 2.5),
    MoodKeyword('i cant breathe', 2.5),
    MoodKeyword('my heart is racing', 2.2),
    MoodKeyword('heart is racing', 2.0),
    MoodKeyword('i am panicking', 2.5),
    MoodKeyword("i'm panicking", 2.5),
    MoodKeyword('i feel overwhelmed', 2.2),
    MoodKeyword('too much', 1.3),
    MoodKeyword('what if', 1.0),
    MoodKeyword('what should i do', 1.2),
    MoodKeyword('i do not know what to do', 1.8),
    MoodKeyword("i don't know what to do", 1.8),
    MoodKeyword('i have no idea what to do', 1.5),
    MoodKeyword('i am freaking out', 2.5),
    MoodKeyword("i'm freaking out", 2.5),
    MoodKeyword('freaking out', 2.2),
    MoodKeyword('i am stressed out', 2.2),
    MoodKeyword("i'm stressed out", 2.2),
    MoodKeyword('cannot stop thinking', 1.8),
    MoodKeyword("can't stop thinking", 1.8),
    MoodKeyword('i keep thinking', 1.5),
    MoodKeyword('my mind is racing', 2.0),
    MoodKeyword('i am afraid of', 2.0),
    MoodKeyword("i'm afraid of", 2.0),
    MoodKeyword('i am scared of', 2.0),
    MoodKeyword("i'm scared of", 2.0),

    // Arabic
    MoodKeyword('قلق', 2.0),
    MoodKeyword('قلقان', 2.0),
    MoodKeyword('قلقانة', 2.0),
    MoodKeyword('توتر', 1.8),
    MoodKeyword('متوتر', 1.8),
    MoodKeyword('متوترة', 1.8),
    MoodKeyword('خايف', 1.8),
    MoodKeyword('خايفة', 1.8),
    MoodKeyword('خوف', 1.8),
    MoodKeyword('مرعوب', 2.5),
    MoodKeyword('مرعوبة', 2.5),
    MoodKeyword('مذعور', 2.3),
    MoodKeyword('مذعورة', 2.3),
    MoodKeyword('رعب', 2.3),
    MoodKeyword('متوتر جدا', 2.2),
    MoodKeyword('متوترة جدا', 2.2),
    MoodKeyword('مضغوط', 1.8),
    MoodKeyword('مضغوطة', 1.8),
    MoodKeyword('ضغط نفسي', 2.0),
    MoodKeyword('متوتر اوي', 2.2),
    MoodKeyword('متوترة اوي', 2.2),
    MoodKeyword('مش عارف اعمل ايه', 1.5),
    MoodKeyword('مش عارفة اعمل ايه', 1.5),
    MoodKeyword('مش عارف أعمل إيه', 1.5),
    MoodKeyword('مش عارفة أعمل إيه', 1.5),
    MoodKeyword('مش عارف اتصرف', 1.5),
    MoodKeyword('مش عارفة اتصرف', 1.5),
    MoodKeyword('قلبي بيدق بسرعة', 2.2),
    MoodKeyword('قلبي بيدق بسرعه', 2.2),
    MoodKeyword('مش قادر اتنفس', 2.5),
    MoodKeyword('مش قادرة اتنفس', 2.5),
    MoodKeyword('مش قادر أتنفس', 2.5),
    MoodKeyword('مش قادرة أتنفس', 2.5),
    MoodKeyword('حاسس بخوف', 2.0),
    MoodKeyword('حاسة بخوف', 2.0),
    MoodKeyword('حاسس بقلق', 2.0),
    MoodKeyword('حاسة بقلق', 2.0),
    MoodKeyword('خايف من', 1.8),
    MoodKeyword('خايفة من', 1.8),
    MoodKeyword('محتار', 1.2),
    MoodKeyword('محتارة', 1.2),
    MoodKeyword('مش مطمن', 1.8),
    MoodKeyword('مش مطمنة', 1.8),
    MoodKeyword('مش مرتاح', 1.5),
    MoodKeyword('مش مرتاحة', 1.5),
    MoodKeyword('الدنيا مقلقاني', 2.0),
    MoodKeyword('الدنيا قلقاني', 2.0),
    MoodKeyword('بفكر كتير', 1.8),
    MoodKeyword('بفكر زيادة', 1.8),
    MoodKeyword('دماغي مشغولة', 1.8),
    MoodKeyword('دماغي مش بتوقف', 2.0),
    MoodKeyword('مش عارف انام', 1.8),
    MoodKeyword('مش عارفة انام', 1.8),
    MoodKeyword('خايف يحصل', 1.8),
    MoodKeyword('خايفة يحصل', 1.8),
    MoodKeyword('قلبي بيجري', 1.8),
    MoodKeyword('حاسس اني هتجنن', 2.0),
    MoodKeyword('حاسة اني هتجنن', 2.0),
    MoodKeyword('أنا متوتر', 1.8),
    MoodKeyword('انا متوتر', 1.8),
    MoodKeyword('أنا متوترة', 1.8),
    MoodKeyword('انا متوترة', 1.8),
    // Arabic (expanded)
    MoodKeyword('ترقب مقلق', 1.8),
    MoodKeyword('قلق شديد', 2.3),
    MoodKeyword('اضطراب', 2.0),
    MoodKeyword('مضطرب', 2.0),
    MoodKeyword('مضطربة', 2.0),
    MoodKeyword('خشية', 1.5),
    MoodKeyword('وجل', 1.8),
    MoodKeyword('ذعر', 2.3),
    MoodKeyword('هلع', 2.4),
    MoodKeyword('مهلوع', 2.3),
    MoodKeyword('مهلوعة', 2.3),
    MoodKeyword('خائف جدا', 2.3),
    MoodKeyword('خائفة جدا', 2.3),
    MoodKeyword('شعور بالاختناق', 2.3),
    MoodKeyword('ضيق نفسي', 2.0),

    // Egyptian additions
    MoodKeyword('حاسس اني هتخنق', 2.2),
    MoodKeyword('حاسة اني هتخنق', 2.2),
    MoodKeyword('قلبي واقف', 2.0),
    MoodKeyword('قلبي مش مطمن', 2.0),
    MoodKeyword('مش عارف انام من القلق', 2.2),
    MoodKeyword('مش عارفة انام من القلق', 2.2),
    MoodKeyword('حاسس بضغط جامد', 2.0),
    MoodKeyword('حاسة بضغط جامد', 2.0),

    // Arabizi
    MoodKeyword('2ale2', 2.0),
    MoodKeyword('2al2', 2.0),
    MoodKeyword('2al2an', 2.0),
    MoodKeyword('2al2ana', 2.0),
    MoodKeyword('motawater', 1.8),
    MoodKeyword('motawatera', 1.8),
    MoodKeyword('khayef', 1.8),
    MoodKeyword('khayfa', 1.8),
    MoodKeyword('merta3eb', 2.2),
    MoodKeyword('merta3eba', 2.2),
    MoodKeyword('mdaye2', 1.5),
    MoodKeyword('mdaye2a', 1.5),
    MoodKeyword('mash 3aref a3mel eh', 1.5),
    MoodKeyword('mash 3arfa a3mel eh', 1.5),
    MoodKeyword('mesh 3aref a3amel eh', 1.5),
    MoodKeyword('mesh 3arfa a3amel eh', 1.5),
    MoodKeyword('mesh motamen', 1.8),
    MoodKeyword('mesh motamena', 1.8),
    MoodKeyword('2alby byedrob besor3a', 2.2),
    MoodKeyword('mesh 2ader atnafas', 2.5),
    MoodKeyword('mesh 2adra atnafas', 2.5),
    MoodKeyword('bafakar kteer', 1.8),
    MoodKeyword('bafakar zyada', 1.8),
    MoodKeyword('mesh 3aref anam', 1.8),
    MoodKeyword('mesh 3arfa anam', 1.8),
    MoodKeyword('ana motawater', 2.0),
    MoodKeyword('ana motawatera', 2.0),
    // Arabizi (expanded)
    MoodKeyword('2albi wa2ef', 2.0),
    MoodKeyword('mesh 3aref anam mn el2ala2', 2.2),
  ];

  // ---------------------------------------------------------------------------
  // EMOJIS
  // ---------------------------------------------------------------------------

  static const excitedEmojis = <MoodKeyword>[
    MoodKeyword('🤩', 2.0),
    MoodKeyword('🥳', 2.0),
    MoodKeyword('🎉', 2.0),
    MoodKeyword('🎊', 2.0),
    MoodKeyword('🔥', 1.5),
    MoodKeyword('⚡', 1.5),
    MoodKeyword('🚀', 1.5),
    MoodKeyword('🏆', 1.8),
    MoodKeyword('🥇', 1.8),
    MoodKeyword('🎯', 1.3),
    MoodKeyword('💥', 1.5),
    MoodKeyword('🙌', 1.8),
    MoodKeyword('👏', 1.5),
    MoodKeyword('💪', 1.3),
    MoodKeyword('😆', 1.5),
    MoodKeyword('😄', 1.5),
    MoodKeyword('😁', 1.5),
    MoodKeyword('😂', 1.8),
    MoodKeyword('🤣', 2.0),
    MoodKeyword('😎', 1.5),
    MoodKeyword('🤗', 1.5),
    MoodKeyword('🎇', 1.8),
    MoodKeyword('🎆', 1.8),
    MoodKeyword('💫', 1.3),
    MoodKeyword('📣', 1.3),
  ];

  static const happyEmojis = <MoodKeyword>[
    MoodKeyword('😀', 1.5),
    MoodKeyword('😃', 1.5),
    MoodKeyword('😄', 1.5),
    MoodKeyword('😁', 1.5),
    MoodKeyword('😊', 1.8),
    MoodKeyword('☺️', 1.5),
    MoodKeyword('🥰', 2.0),
    MoodKeyword('😍', 1.8),
    MoodKeyword('😘', 1.5),
    MoodKeyword('😌', 1.5),
    MoodKeyword('😇', 1.5),
    MoodKeyword('🤗', 1.5),
    MoodKeyword('❤️', 1.5),
    MoodKeyword('♥️', 1.5),
    MoodKeyword('💕', 1.5),
    MoodKeyword('💖', 1.8),
    MoodKeyword('💗', 1.5),
    MoodKeyword('💓', 1.5),
    MoodKeyword('💞', 1.5),
    MoodKeyword('💝', 1.5),
    MoodKeyword('✨', 1.2),
    MoodKeyword('🌸', 1.0),
    MoodKeyword('🌹', 1.0),
    MoodKeyword('☀️', 1.0),
    MoodKeyword('🙂', 1.2),
    MoodKeyword('😉', 1.0),
    MoodKeyword('🌻', 1.0),
    MoodKeyword('🌼', 1.0),
    MoodKeyword('🍀', 1.0),
    MoodKeyword('🕊️', 1.2),
  ];

  static const sadEmojis = <MoodKeyword>[
    MoodKeyword('😢', 2.0),
    MoodKeyword('😭', 2.5),
    MoodKeyword('😞', 2.0),
    MoodKeyword('😔', 2.0),
    MoodKeyword('😟', 1.8),
    MoodKeyword('😥', 2.0),
    MoodKeyword('😓', 1.8),
    MoodKeyword('😪', 1.8),
    MoodKeyword('🥺', 1.8),
    MoodKeyword('💔', 2.5),
    MoodKeyword('🖤', 1.5),
    MoodKeyword('🥀', 1.8),
    MoodKeyword('😿', 2.0),
    MoodKeyword('🙁', 1.8),
    MoodKeyword('☹️', 1.8),
    MoodKeyword('😣', 1.8),
    MoodKeyword('😩', 1.8),
    MoodKeyword('🥲', 1.8),
    MoodKeyword('😶‍🌫️', 1.5),
  ];

  static const angryEmojis = <MoodKeyword>[
    MoodKeyword('😡', 2.5),
    MoodKeyword('😠', 2.5),
    MoodKeyword('🤬', 2.5),
    MoodKeyword('😤', 2.0),
    MoodKeyword('😾', 2.0),
    MoodKeyword('👿', 2.2),
    MoodKeyword('😈', 1.5),
    MoodKeyword('💢', 2.0),
    MoodKeyword('🤯', 2.0),
    MoodKeyword('🔥', 1.2),
    MoodKeyword('💥', 1.5),
    MoodKeyword('👊', 1.3),
    MoodKeyword('😑', 1.3),
    MoodKeyword('🙄', 1.5),
    MoodKeyword('💣', 1.5),
  ];

  static const anxiousEmojis = <MoodKeyword>[
    MoodKeyword('😰', 2.0),
    MoodKeyword('😨', 2.0),
    MoodKeyword('😱', 2.5),
    MoodKeyword('😟', 1.8),
    MoodKeyword('😧', 2.0),
    MoodKeyword('😦', 1.8),
    MoodKeyword('😥', 1.8),
    MoodKeyword('😓', 1.8),
    MoodKeyword('😬', 1.8),
    MoodKeyword('🫨', 2.0),
    MoodKeyword('😵', 1.8),
    MoodKeyword('😵‍💫', 2.0),
    MoodKeyword('🫣', 1.8),
    MoodKeyword('🥶', 1.5),
    MoodKeyword('💀', 1.0),
    MoodKeyword('😮‍💨', 1.5),
    MoodKeyword('🫠', 1.5),
  ];
}
