import 'package:injectable/injectable.dart';
import 'package:pulse/core/constants/mood.dart';

class MoodKeyword {
  final String phrase;
  final double weight;

  const MoodKeyword(this.phrase, this.weight);
}

@lazySingleton
class MoodDetectionService {
  // ---------------------------------------------------------------------------
  // EXCITED
  // ---------------------------------------------------------------------------

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

    // English phrases
    MoodKeyword('leave me alone', 1.8),
    MoodKeyword('get out', 1.5),
    MoodKeyword('shut up', 1.8),
    MoodKeyword('go away', 1.5),
    MoodKeyword('this is annoying', 2.0),
    MoodKeyword('you are annoying', 2.0),
    MoodKeyword("you're annoying", 2.0),
    MoodKeyword('i am done', 1.8),
    MoodKeyword("i'm done", 1.8),
    MoodKeyword('i am sick of this', 2.2),
    MoodKeyword("i'm sick of this", 2.2),
    MoodKeyword('i am fed up', 2.2),
    MoodKeyword("i'm fed up", 2.2),
    MoodKeyword('this makes me angry', 2.5),
    MoodKeyword('this makes me mad', 2.2),
    MoodKeyword('this is ridiculous', 2.2),
    MoodKeyword('this is unacceptable', 2.2),
    MoodKeyword('how dare you', 2.2),
    MoodKeyword('not again', 1.5),
    MoodKeyword('are you serious', 1.5),
    MoodKeyword('you have got to be kidding', 1.8),
    MoodKeyword('i cannot take this', 2.0),
    MoodKeyword("i can't take this", 2.0),
    MoodKeyword('stop it', 1.5),
    MoodKeyword('stop doing that', 1.5),

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
    MoodKeyword('بطل بقى', 1.8),
    MoodKeyword('سيبني', 1.5),
    MoodKeyword('ابعد', 1.2),

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
    MoodKeyword('restless', 1.5),
    MoodKeyword('shaking', 1.8),
    MoodKeyword('shaky', 1.8),
    MoodKeyword('scary', 1.8),
    MoodKeyword('worst case', 1.5),
    MoodKeyword('unclear', 1.0),

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
    MoodKeyword('2alby byedrob besor3a', 2.2),
    MoodKeyword('mesh 2ader atnafas', 2.5),
    MoodKeyword('mesh 2adra atnafas', 2.5),
    MoodKeyword('bafakar kteer', 1.8),
    MoodKeyword('bafakar zyada', 1.8),
    MoodKeyword('mesh 3aref anam', 1.8),
    MoodKeyword('mesh 3arfa anam', 1.8),
    MoodKeyword('ana motawater', 2.0),
    MoodKeyword('ana motawatera', 2.0),
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
    MoodKeyword('😢', 2.0),
    MoodKeyword('🥺', 1.8),
    MoodKeyword('💔', 2.5),
    MoodKeyword('🖤', 1.5),
    MoodKeyword('🥀', 1.8),
    MoodKeyword('😿', 2.0),
    MoodKeyword('🙁', 1.8),
    MoodKeyword('☹️', 1.8),
    MoodKeyword('😣', 1.8),
    MoodKeyword('😩', 1.8),
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
  ];

  // ---------------------------------------------------------------------------
  // DETECTION
  // ---------------------------------------------------------------------------

  Future<Mood> detectMood(String text) async {
    if (text.trim().isEmpty) {
      return Mood.neutral;
    }

    final normalized = normalizeText(text);
    final wordCount =
        normalized.isEmpty ? 0 : normalized.split(RegExp(r'\s+')).length;

    final score = <Mood, double>{
      Mood.excited: _scoreMoodKeywords(
        normalized,
        excitedKeywords,
      ),
      Mood.happy: _scoreMoodKeywords(
        normalized,
        happyKeywords,
      ),
      Mood.sad: _scoreMoodKeywords(
        normalized,
        sadKeywords,
      ),
      Mood.angry: _scoreMoodKeywords(
        normalized,
        angryKeywords,
      ),
      Mood.anxious: _scoreMoodKeywords(
        normalized,
        anxiousKeywords,
      ),
      Mood.neutral: 0,
    };

    // -----------------------------------------------------------------------
    // Emoji scoring
    // -----------------------------------------------------------------------

    score[Mood.excited] =
        (score[Mood.excited] ?? 0) + _scoreEmojis(text, excitedEmojis);

    score[Mood.happy] =
        (score[Mood.happy] ?? 0) + _scoreEmojis(text, happyEmojis);

    score[Mood.sad] = (score[Mood.sad] ?? 0) + _scoreEmojis(text, sadEmojis);

    score[Mood.angry] =
        (score[Mood.angry] ?? 0) + _scoreEmojis(text, angryEmojis);

    score[Mood.anxious] =
        (score[Mood.anxious] ?? 0) + _scoreEmojis(text, anxiousEmojis);

    // -----------------------------------------------------------------------
    // Punctuation / intensity
    // -----------------------------------------------------------------------

    final exclamationCount = '!'.allMatches(text).length;
    final questionCount = '?'.allMatches(text).length;

    if (exclamationCount > 0) {
      score[Mood.excited] =
          (score[Mood.excited] ?? 0) + (exclamationCount >= 3 ? 0.8 : 0.3);

      score[Mood.happy] =
          (score[Mood.happy] ?? 0) + (exclamationCount >= 3 ? 0.3 : 0.1);

      // Strong punctuation can also indicate anger.
      if (exclamationCount >= 2) {
        score[Mood.angry] = (score[Mood.angry] ?? 0) + 0.2;
      }
    }

    if (questionCount >= 2) {
      score[Mood.anxious] = (score[Mood.anxious] ?? 0) + 0.3;
    }

    // -----------------------------------------------------------------------
    // Negation handling
    //
    // Prevent common phrases such as:
    // "not happy"
    // "not good"
    // "don't love"
    // "مش مبسوط"
    //
    // from being incorrectly classified as positive.
    // -----------------------------------------------------------------------

    _applyNegationAdjustments(normalized, score);

    // -----------------------------------------------------------------------
    // Repeated punctuation / uppercase intensity
    // -----------------------------------------------------------------------

    final uppercaseRatio = _uppercaseRatio(text);

    if (uppercaseRatio >= 0.65 && text.length >= 6) {
      score[Mood.excited] = (score[Mood.excited] ?? 0) + 0.3;
      score[Mood.angry] = (score[Mood.angry] ?? 0) + 0.2;
    }

    // -----------------------------------------------------------------------
    // Neutral threshold
    // -----------------------------------------------------------------------

    final maxScore = score.values.reduce(
      (a, b) => a > b ? a : b,
    );

    final threshold = wordCount <= 2 ? 0.2 : 0.1;

    if (maxScore < threshold) {
      return Mood.neutral;
    }

    // -----------------------------------------------------------------------
    // Find strongest mood.
    //
    // In case of a very close result, prefer the more specific/intense mood.
    // -----------------------------------------------------------------------

    Mood bestMood = Mood.neutral;
    double bestScore = double.negativeInfinity;

    for (final entry in score.entries) {
      if (entry.key == Mood.neutral) {
        continue;
      }

      if (entry.value > bestScore) {
        bestScore = entry.value;
        bestMood = entry.key;
      }
    }

    return bestMood;
  }

  // ---------------------------------------------------------------------------
  // KEYWORD SCORING
  // ---------------------------------------------------------------------------

  double _scoreMoodKeywords(
    String text,
    List<MoodKeyword> keywords,
  ) {
    double score = 0;

    for (final keyword in keywords) {
      // Normalize the keyword too.
      //
      // This is important for Arabic because normalizeText() transforms:
      // أ -> ا
      // إ -> ا
      // آ -> ا
      // ة -> ه
      // ى -> ي
      //
      // Therefore both the user's input and the keyword must go through the
      // same normalization process.
      final normalizedKeyword = normalizeText(keyword.phrase);

      if (normalizedKeyword.isEmpty) {
        continue;
      }

      if (text.contains(normalizedKeyword)) {
        score += keyword.weight;
      }
    }

    return score;
  }

  double _scoreEmojis(
    String originalText,
    List<MoodKeyword> emojis,
  ) {
    double score = 0;

    for (final emoji in emojis) {
      if (originalText.contains(emoji.phrase)) {
        score += emoji.weight;
      }
    }

    return score;
  }

  // ---------------------------------------------------------------------------
  // NEGATION
  // ---------------------------------------------------------------------------

  void _applyNegationAdjustments(
    String text,
    Map<Mood, double> score,
  ) {
    final positiveNegations = <String>[
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
      'مش مبسوط',
      'مش مبسوطة',
      'مش سعيد',
      'مش سعيدة',
      'مش فرحان',
      'مش فرحانة',
      'مش كويس',
      'مش كويسة',
      'مش تمام',
      'مش متحمس',
      'مش متحمسة',
      'مش عاجبني',
      'مش عاجباني',
      'مش بحب',
      'مش بحبه',
      'مش بحبها',
    ];

    final sadNegations = <String>[
      'not sad',
      'not unhappy',
      'not lonely',
      'not crying',
      'not depressed',
      'مش حزين',
      'مش حزينة',
      'مش زعلان',
      'مش زعلانة',
      'مش وحيد',
      'مش وحيدة',
      'مش بعيط',
      'مش مكتئب',
      'مش مكتئبة',
    ];

    for (final phrase in positiveNegations) {
      if (text.contains(normalizeText(phrase))) {
        score[Mood.happy] = (score[Mood.happy] ?? 0) * 0.25;
        score[Mood.excited] = (score[Mood.excited] ?? 0) * 0.35;

        // A negated positive phrase is usually neutral or negative.
        score[Mood.sad] = (score[Mood.sad] ?? 0) + 0.4;
      }
    }

    for (final phrase in sadNegations) {
      if (text.contains(normalizeText(phrase))) {
        score[Mood.sad] = (score[Mood.sad] ?? 0) * 0.25;
      }
    }

    // Anxiety negation.
    final anxietyNegations = <String>[
      'not worried',
      'not anxious',
      'not scared',
      'not afraid',
      'not nervous',
      'dont worry',
      "don't worry",
      'do not worry',
      'مش قلقان',
      'مش قلقانة',
      'مش خايف',
      'مش خايفة',
      'مش متوتر',
      'مش متوترة',
      'مش خايف من',
      'مش خايفة من',
    ];

    for (final phrase in anxietyNegations) {
      if (text.contains(normalizeText(phrase))) {
        score[Mood.anxious] = (score[Mood.anxious] ?? 0) * 0.25;
      }
    }
  }

  // ---------------------------------------------------------------------------
  // UPPERCASE DETECTION
  // ---------------------------------------------------------------------------

  double _uppercaseRatio(String text) {
    final letters = text.runes
        .map(String.fromCharCode)
        .where((char) => RegExp(r'[A-Za-z]').hasMatch(char))
        .toList();

    if (letters.isEmpty) {
      return 0;
    }

    final uppercase =
        letters.where((char) => char == char.toUpperCase()).length;

    return uppercase / letters.length;
  }

  // ---------------------------------------------------------------------------
  // TEXT NORMALIZATION
  // ---------------------------------------------------------------------------

  String normalizeText(String input) {
    var text = input.toLowerCase().trim();

    // -------------------------------------------------------------------------
    // Normalize Arabic letters.
    // -------------------------------------------------------------------------

    text = text
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ٱ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي');

    // -------------------------------------------------------------------------
    // Normalize Arabic diacritics.
    // -------------------------------------------------------------------------

    text = text.replaceAll(
      RegExp(r'[\u064B-\u065F\u0670]'),
      '',
    );

    // -------------------------------------------------------------------------
    // Normalize Arabic tatweel:
    //
    // "جــــامد" -> "جامد"
    // -------------------------------------------------------------------------

    text = text.replaceAll('ـ', '');

    // -------------------------------------------------------------------------
    // Normalize common Arabic punctuation.
    // -------------------------------------------------------------------------

    text = text
        .replaceAll('،', ' ')
        .replaceAll('؛', ' ')
        .replaceAll('؟', ' ')
        .replaceAll('«', ' ')
        .replaceAll('»', ' ')
        .replaceAll('“', ' ')
        .replaceAll('”', ' ')
        .replaceAll('‘', "'")
        .replaceAll('’', "'");

    // -------------------------------------------------------------------------
    // Normalize repeated characters.
    //
    // "soooo happy" -> "soo happy"
    // "حلووووو"     -> "حلو"
    //
    // Keeping two characters helps preserve expressive words while still
    // allowing the regular keyword to match.
    // -------------------------------------------------------------------------

    text = text.replaceAll(
      RegExp(r'(.)\1{2,}'),
      r'$1$1',
    );

    // -------------------------------------------------------------------------
    // Keep Arabic, English, numbers, spaces, and apostrophes.
    // -------------------------------------------------------------------------

    text = text.replaceAll(
      RegExp(r"[^\u0600-\u06FFa-z0-9\s']"),
      ' ',
    );

    // -------------------------------------------------------------------------
    // Collapse multiple spaces.
    // -------------------------------------------------------------------------

    text = text.replaceAll(
      RegExp(r'\s+'),
      ' ',
    );

    return text.trim();
  }
}
