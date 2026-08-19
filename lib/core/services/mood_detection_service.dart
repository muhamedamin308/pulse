import 'package:injectable/injectable.dart';
import 'package:pulse/core/constants/mood.dart';

class MoodKeyword {
  final String phrase;
  final double weight;

  const MoodKeyword(this.phrase, this.weight);
}

@lazySingleton
class MoodDetectionService {
  static const excitedKeywords = <MoodKeyword>[
    // English
    MoodKeyword('amazing', 2.0),
    MoodKeyword('awesome', 2.0),
    MoodKeyword('fantastic', 2.0),
    MoodKeyword('incredible', 2.0),
    MoodKeyword('wonderful', 1.5),
    MoodKeyword('excellent', 1.8),
    MoodKeyword('brilliant', 1.8),
    MoodKeyword('outstanding', 1.8),
    MoodKeyword('superb', 1.8),
    MoodKeyword('yay', 2.0),
    MoodKeyword('woohoo', 2.0),
    MoodKeyword("let's go", 2.0),
    MoodKeyword('lets go', 2.0),
    MoodKeyword('omg', 1.5),
    MoodKeyword('wow', 1.5),
    MoodKeyword('insane', 1.5),
    MoodKeyword('unbelievable', 1.8),
    MoodKeyword('thrilled', 2.0),
    MoodKeyword('ecstatic', 2.5),
    MoodKeyword('pumped', 2.0),
    MoodKeyword('stoked', 2.0),
    MoodKeyword('hyped', 2.0),
    MoodKeyword('epic', 1.8),
    MoodKeyword('legendary', 1.8),
    MoodKeyword('fire', 1.5),
    MoodKeyword('lit', 1.5),
    MoodKeyword('yasss', 2.0),
    MoodKeyword('yass', 2.0),
    MoodKeyword('woot', 2.0),
    MoodKeyword('whoa', 1.5),
    MoodKeyword('dope', 1.5),
    MoodKeyword('can’t wait', 2.0),
    MoodKeyword('cant wait', 2.0),
    MoodKeyword('so excited', 2.5),
    MoodKeyword('really excited', 2.5),
    MoodKeyword('best day ever', 2.5),
    MoodKeyword('this is awesome', 2.5),
    MoodKeyword('i am so happy', 1.5),

    // Modern Standard Arabic
    MoodKeyword('متحمس', 2.0),
    MoodKeyword('متحمسة', 2.0),
    MoodKeyword('متحمس جدًا', 2.5),
    MoodKeyword('متحمسة جدًا', 2.5),
    MoodKeyword('متحمس جدا', 2.5),
    MoodKeyword('متحمسة جدا', 2.5),
    MoodKeyword('سعيد جدًا', 2.0),
    MoodKeyword('سعيدة جدًا', 2.0),
    MoodKeyword('فرح شديد', 2.0),
    MoodKeyword('مبتهج', 2.0),
    MoodKeyword('مبتهجة', 2.0),
    MoodKeyword('رائع جدًا', 2.0),
    MoodKeyword('مذهل', 2.0),
    MoodKeyword('مذهلة', 2.0),
    MoodKeyword('لا أستطيع الانتظار', 2.5),
    MoodKeyword('لا استطيع الانتظار', 2.5),
    MoodKeyword('يا له من شيء رائع', 2.0),
    MoodKeyword('هذا رائع', 1.8),

    // Egyptian Arabic
    MoodKeyword('مبسوط أوي', 2.5),
    MoodKeyword('مبسوطة أوي', 2.5),
    MoodKeyword('مبسوط اوي', 2.5),
    MoodKeyword('مبسوطة اوي', 2.5),
    MoodKeyword('فرحان أوي', 2.5),
    MoodKeyword('فرحانة أوي', 2.5),
    MoodKeyword('فرحان اوي', 2.5),
    MoodKeyword('فرحانة اوي', 2.5),
    MoodKeyword('متحمس أوي', 2.5),
    MoodKeyword('متحمسة أوي', 2.5),
    MoodKeyword('جامد أوي', 1.8),
    MoodKeyword('جامدة أوي', 1.8),
    MoodKeyword('تحفة', 1.8),
    MoodKeyword('عظمة', 1.8),
    MoodKeyword('يا سلام', 1.5),
    MoodKeyword('يلا بينا', 1.5),
    MoodKeyword('مش قادر أستنى', 2.0),
    MoodKeyword('مش قادرة أستنى', 2.0),
    MoodKeyword('الدنيا حلوة', 1.8),
    MoodKeyword('أنا طاير من الفرحة', 2.5),
    MoodKeyword('انا طاير من الفرحة', 2.5),
    MoodKeyword('أنا طايرة من الفرحة', 2.5),
    MoodKeyword('انا طايرة من الفرحة', 2.5),

    // Arabizi
    MoodKeyword('mabsout', 1.8),
    MoodKeyword('mabsoota', 1.8),
    MoodKeyword('farhan', 1.8),
    MoodKeyword('farhana', 1.8),
    MoodKeyword('mot7ames', 2.0),
    MoodKeyword('mota7ames', 2.0),
    MoodKeyword('gamda awy', 1.8),
    MoodKeyword('ta7fa', 1.8),
    MoodKeyword('yalla bina', 1.5),
    MoodKeyword('mesh 2ader astana', 2.0),
  ];

  static const happyKeywords = <MoodKeyword>[
    // English
    MoodKeyword('happy', 1.5),
    MoodKeyword('glad', 1.5),
    MoodKeyword('good', 0.8),
    MoodKeyword('nice', 1.0),
    MoodKeyword('love', 1.5),
    MoodKeyword('like', 0.8),
    MoodKeyword('enjoy', 1.2),
    MoodKeyword('pleased', 1.5),
    MoodKeyword('delighted', 1.8),
    MoodKeyword('joy', 1.8),
    MoodKeyword('joyful', 1.8),
    MoodKeyword('smile', 1.2),
    MoodKeyword('smiling', 1.2),
    MoodKeyword('laugh', 1.2),
    MoodKeyword('laughing', 1.2),
    MoodKeyword('fun', 1.0),
    MoodKeyword('blessed', 1.5),
    MoodKeyword('grateful', 1.5),
    MoodKeyword('thankful', 1.5),
    MoodKeyword('appreciate', 1.2),
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
    MoodKeyword('loved', 1.5),
    MoodKeyword('safe', 1.0),
    MoodKeyword('everything is fine', 1.2),
    MoodKeyword('feeling good', 1.5),
    MoodKeyword('in a good mood', 1.8),
    MoodKeyword('made my day', 1.8),

    // Arabic
    MoodKeyword('سعيد', 1.5),
    MoodKeyword('سعيدة', 1.5),
    MoodKeyword('فرحان', 1.5),
    MoodKeyword('فرحانة', 1.5),
    MoodKeyword('فرح', 1.2),
    MoodKeyword('فرحان جدًا', 2.0),
    MoodKeyword('فرحانة جدًا', 2.0),
    MoodKeyword('مبسوط', 1.5),
    MoodKeyword('مبسوطة', 1.5),
    MoodKeyword('مسرور', 1.5),
    MoodKeyword('مسرورة', 1.5),
    MoodKeyword('مبهج', 1.5),
    MoodKeyword('مبهجة', 1.5),
    MoodKeyword('ممتن', 1.5),
    MoodKeyword('ممتنة', 1.5),
    MoodKeyword('شكراً', 0.8),
    MoodKeyword('شكرا', 0.8),
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
    MoodKeyword('زي الفل', 1.8),
    MoodKeyword('تمام التمام', 1.8),
    MoodKeyword('مبسوط أوي', 2.0),
    MoodKeyword('مبسوطة أوي', 2.0),
    MoodKeyword('قلبي فرحان', 2.0),

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
    MoodKeyword('kwayes', 1.0),
    MoodKeyword('kwayesa', 1.0),
    MoodKeyword('zay el fol', 1.8),
    MoodKeyword('el 7amdulillah', 1.5),
  ];

  static const sadKeywords = <MoodKeyword>[
    // English
    MoodKeyword('sad', 1.8),
    MoodKeyword('unhappy', 1.8),
    MoodKeyword('depressed', 2.5),
    MoodKeyword('down', 1.2),
    MoodKeyword('blue', 1.2),
    MoodKeyword('cry', 1.8),
    MoodKeyword('crying', 2.0),
    MoodKeyword('tears', 1.8),
    MoodKeyword('miss', 1.2),
    MoodKeyword('missing', 1.5),
    MoodKeyword('lonely', 2.0),
    MoodKeyword('alone', 1.5),
    MoodKeyword('heartbroken', 2.5),
    MoodKeyword('hurt', 1.8),
    MoodKeyword('pain', 1.8),
    MoodKeyword('sorrow', 2.0),
    MoodKeyword('grief', 2.5),
    MoodKeyword('mourn', 2.5),
    MoodKeyword('disappointed', 1.8),
    MoodKeyword('regret', 1.5),
    MoodKeyword('sorry', 0.8),
    MoodKeyword('unfortunate', 1.2),
    MoodKeyword('miserable', 2.2),
    MoodKeyword('gloomy', 1.8),
    MoodKeyword('hopeless', 2.2),
    MoodKeyword('helpless', 2.0),
    MoodKeyword('empty', 2.0),
    MoodKeyword('lost', 1.2),
    MoodKeyword('broken', 2.2),
    MoodKeyword('tired', 1.0),
    MoodKeyword('exhausted', 1.5),
    MoodKeyword('drained', 1.5),
    MoodKeyword('devastated', 2.5),
    MoodKeyword('melancholy', 2.0),
    MoodKeyword('i feel awful', 2.0),
    MoodKeyword('i feel terrible', 2.0),
    MoodKeyword('not okay', 2.0),
    MoodKeyword('not ok', 2.0),
    MoodKeyword('nothing matters', 2.5),
    MoodKeyword('i feel alone', 2.2),
    MoodKeyword('i miss you', 2.0),
    MoodKeyword('i cannot stop crying', 2.5),

    // Arabic
    MoodKeyword('حزين', 1.8),
    MoodKeyword('حزينة', 1.8),
    MoodKeyword('زعلان', 1.8),
    MoodKeyword('زعلانة', 1.8),
    MoodKeyword('مضايق', 1.5),
    MoodKeyword('مضايقة', 1.5),
    MoodKeyword('مكتئب', 2.5),
    MoodKeyword('مكتئبة', 2.5),
    MoodKeyword('كئيب', 2.0),
    MoodKeyword('كئيبة', 2.0),
    MoodKeyword('وحيد', 2.0),
    MoodKeyword('وحيدة', 2.0),
    MoodKeyword('لوحدي', 1.8),
    MoodKeyword('حاسة بالوحدة', 2.2),
    MoodKeyword('حاسس بالوحدة', 2.2),
    MoodKeyword('بعيط', 2.0),
    MoodKeyword('ببكي', 2.0),
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
    MoodKeyword('وحشتني', 1.8),
    MoodKeyword('وحشتيني', 1.8),
    MoodKeyword('وحشتني أوي', 2.2),
    MoodKeyword('محبط', 1.8),
    MoodKeyword('محبطة', 1.8),
    MoodKeyword('محبط جدًا', 2.2),
    MoodKeyword('محبطة جدًا', 2.2),
    MoodKeyword('يائس', 2.2),
    MoodKeyword('يائسة', 2.2),
    MoodKeyword('فاقد الأمل', 2.2),
    MoodKeyword('فاقدة الأمل', 2.2),
    MoodKeyword('تعبان', 1.2),
    MoodKeyword('تعبانة', 1.2),
    MoodKeyword('مرهق', 1.5),
    MoodKeyword('مرهقة', 1.5),
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

    // Arabizi
    MoodKeyword('7azeen', 1.8),
    MoodKeyword('7azeena', 1.8),
    MoodKeyword('za3lan', 1.8),
    MoodKeyword('za3lana', 1.8),
    MoodKeyword('wa7eed', 2.0),
    MoodKeyword('wa7eeda', 2.0),
    MoodKeyword('ba3ayet', 2.0),
    MoodKeyword('meكسور', 2.0),
    MoodKeyword('meksour', 2.0),
    MoodKeyword('merta7', 1.0),
    MoodKeyword('wa7ashteny', 1.8),
    MoodKeyword('ta3ban', 1.5),
    MoodKeyword('ta3bana', 1.5),
    MoodKeyword('mesh tamam', 1.8),
  ];

  static const angryKeywords = <MoodKeyword>[
    // English
    MoodKeyword('angry', 2.0),
    MoodKeyword('mad', 1.5),
    MoodKeyword('furious', 2.5),
    MoodKeyword('rage', 2.5),
    MoodKeyword('raging', 2.5),
    MoodKeyword('hate', 1.8),
    MoodKeyword('hating', 1.8),
    MoodKeyword('annoyed', 1.8),
    MoodKeyword('irritated', 1.8),
    MoodKeyword('frustrated', 1.8),
    MoodKeyword('upset', 1.5),
    MoodKeyword('outraged', 2.2),
    MoodKeyword('infuriated', 2.5),
    MoodKeyword('livid', 2.5),
    MoodKeyword('disgusted', 2.0),
    MoodKeyword('horrible', 1.5),
    MoodKeyword('terrible', 1.5),
    MoodKeyword('awful', 1.5),
    MoodKeyword('stupid', 1.5),
    MoodKeyword('idiot', 1.8),
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
    MoodKeyword('leave me alone', 1.8),
    MoodKeyword('get out', 1.5),
    MoodKeyword('shut up', 1.8),
    MoodKeyword('this is annoying', 2.0),
    MoodKeyword('you are annoying', 2.0),
    MoodKeyword('i am done', 1.8),

    // Arabic
    MoodKeyword('غاضب', 2.0),
    MoodKeyword('غاضبة', 2.0),
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
    MoodKeyword('مخنوق', 1.5),
    MoodKeyword('مخنوقة', 1.5),
    MoodKeyword('كره', 1.8),
    MoodKeyword('بكره', 1.8),
    MoodKeyword('بكرهه', 1.8),
    MoodKeyword('بكرهها', 1.8),
    MoodKeyword('غضب', 2.0),
    MoodKeyword('عصبية جدًا', 2.3),
    MoodKeyword('عصبيه جدا', 2.3),
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

    // Arabizi
    MoodKeyword('3asban', 1.8),
    MoodKeyword('3asbana', 1.8),
    MoodKeyword('mdaye2', 1.8),
    MoodKeyword('mdaye2a', 1.8),
    MoodKeyword('metdaye2', 1.8),
    MoodKeyword('metdaye2a', 1.8),
    MoodKeyword('mesh tay2', 2.0),
    MoodKeyword('mesh tay2a', 2.0),
    MoodKeyword('kefaya', 1.5),
    MoodKeyword('seebny lwa7dy', 1.8),
    MoodKeyword('eb3ad 3any', 1.8),
  ];

  static const anxiousKeywords = <MoodKeyword>[
    // English
    MoodKeyword('anxious', 2.0),
    MoodKeyword('anxiety', 2.0),
    MoodKeyword('nervous', 1.8),
    MoodKeyword('scared', 1.8),
    MoodKeyword('afraid', 1.8),
    MoodKeyword('fear', 1.8),
    MoodKeyword('worried', 1.8),
    MoodKeyword('worry', 1.5),
    MoodKeyword('stress', 1.5),
    MoodKeyword('stressed', 1.8),
    MoodKeyword('panic', 2.5),
    MoodKeyword('panicking', 2.5),
    MoodKeyword('overwhelmed', 2.0),
    MoodKeyword('uncertain', 1.2),
    MoodKeyword('unsure', 1.2),
    MoodKeyword('doubt', 1.2),
    MoodKeyword('doubtful', 1.2),
    MoodKeyword('terrified', 2.5),
    MoodKeyword('horrified', 2.2),
    MoodKeyword('dread', 2.0),
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
    MoodKeyword('under pressure', 1.8),
    MoodKeyword('i am scared', 2.0),
    MoodKeyword('i am worried', 2.0),
    MoodKeyword('i feel unsafe', 2.2),
    MoodKeyword('what if', 1.0),
    MoodKeyword('i cannot relax', 2.0),
    MoodKeyword('i can’t breathe', 2.5),
    MoodKeyword('i cant breathe', 2.5),
    MoodKeyword('my heart is racing', 2.2),

    // Arabic
    MoodKeyword('قلق', 2.0),
    MoodKeyword('قلقان', 2.0),
    MoodKeyword('قلقانة', 2.0),
    MoodKeyword('متوتر', 1.8),
    MoodKeyword('متوترة', 1.8),
    MoodKeyword('خايف', 1.8),
    MoodKeyword('خايفة', 1.8),
    MoodKeyword('خوف', 1.8),
    MoodKeyword('مرعوب', 2.5),
    MoodKeyword('مرعوبة', 2.5),
    MoodKeyword('مذعور', 2.3),
    MoodKeyword('مذعورة', 2.3),
    MoodKeyword('متوتر جدًا', 2.2),
    MoodKeyword('متوترة جدًا', 2.2),
    MoodKeyword('مضغوط', 1.8),
    MoodKeyword('مضغوطة', 1.8),
    MoodKeyword('ضغط نفسي', 2.0),
    MoodKeyword('متوتر أوي', 2.2),
    MoodKeyword('متوترة أوي', 2.2),
    MoodKeyword('مش عارف أعمل إيه', 1.5),
    MoodKeyword('مش عارفة أعمل إيه', 1.5),
    MoodKeyword('مش عارف أتصرف', 1.5),
    MoodKeyword('مش عارفة أتصرف', 1.5),
    MoodKeyword('قلبي بيدق بسرعة', 2.2),
    MoodKeyword('مش قادر أتنفس', 2.5),
    MoodKeyword('مش قادرة أتنفس', 2.5),
    MoodKeyword('حاسس بخوف', 2.0),
    MoodKeyword('حاسة بخوف', 2.0),
    MoodKeyword('خايف من', 1.8),
    MoodKeyword('خايفة من', 1.8),
    MoodKeyword('محتار', 1.2),
    MoodKeyword('محتارة', 1.2),
    MoodKeyword('مش مطمن', 1.8),
    MoodKeyword('مش مطمنة', 1.8),
    MoodKeyword('مش مرتاح', 1.5),
    MoodKeyword('مش مرتاحة', 1.5),
    MoodKeyword('الدنيا مقلقاني', 2.0),
    MoodKeyword('أنا متوتر', 1.8),
    MoodKeyword('انا متوتر', 1.8),
    MoodKeyword('أنا متوترة', 1.8),
    MoodKeyword('انا متوترة', 1.8),

    // Arabizi
    MoodKeyword('2ale2', 2.0),
    MoodKeyword('2al2an', 2.0),
    MoodKeyword('2al2ana', 2.0),
    MoodKeyword('motawater', 1.8),
    MoodKeyword('motawatera', 1.8),
    MoodKeyword('khayef', 1.8),
    MoodKeyword('khayfa', 1.8),
    MoodKeyword('metdaye2', 1.5),
    MoodKeyword('mash 3aref a3mel eh', 1.5),
    MoodKeyword('mash 3arfa a3mel eh', 1.5),
    MoodKeyword('mesh motamen', 1.8),
    MoodKeyword('mesh motamena', 1.8),
    MoodKeyword('2alby byedrob besor3a', 2.2),
  ];

  static const emojiKeywords = <MoodKeyword>[
    MoodKeyword('😀', 1.5),
    MoodKeyword('😃', 1.5),
    MoodKeyword('😄', 1.5),
    MoodKeyword('😁', 1.5),
    MoodKeyword('😂', 2.0),
    MoodKeyword('🤣', 2.0),
    MoodKeyword('😍', 1.8),
    MoodKeyword('🥳', 2.0),
    MoodKeyword('🎉', 2.0),
    MoodKeyword('🔥', 1.5),
    MoodKeyword('❤️', 1.5),
    MoodKeyword('😊', 1.5),
    MoodKeyword('😢', 2.0),
    MoodKeyword('😭', 2.5),
    MoodKeyword('💔', 2.5),
    MoodKeyword('😞', 2.0),
    MoodKeyword('😔', 2.0),
    MoodKeyword('😡', 2.5),
    MoodKeyword('😠', 2.5),
    MoodKeyword('🤬', 2.5),
    MoodKeyword('😤', 2.0),
    MoodKeyword('😰', 2.0),
    MoodKeyword('😨', 2.0),
    MoodKeyword('😱', 2.5),
    MoodKeyword('😟', 1.8),
  ];

  Future<Mood> detectMood(String text) async {
    if (text.trim().isEmpty) return Mood.neutral;

    final normalized = normalizeText(text);
    final hasExclamation = text.contains('!');
    final wordCount = normalized.split(' ').length;

    final score = <Mood, double>{
      Mood.excited: _scoreMoodKeywords(normalized, excitedKeywords),
      Mood.happy: _scoreMoodKeywords(normalized, happyKeywords),
      Mood.sad: _scoreMoodKeywords(normalized, sadKeywords),
      Mood.angry: _scoreMoodKeywords(normalized, angryKeywords),
      Mood.anxious: _scoreMoodKeywords(normalized, anxiousKeywords),
      Mood.neutral: 0,
    };

    // Emoji scoring on original text
    score[Mood.excited] = (score[Mood.excited] ?? 0) +
        _scoreEmojis(text, const [
          MoodKeyword('😀', 1.5),
          MoodKeyword('😃', 1.5),
          MoodKeyword('🥳', 2.0),
          MoodKeyword('🎉', 2.0),
          MoodKeyword('🔥', 1.5),
          MoodKeyword('😂', 2.0),
          MoodKeyword('🤣', 2.0),
        ]);
    score[Mood.happy] = (score[Mood.happy] ?? 0) +
        _scoreEmojis(text, const [
          MoodKeyword('😊', 1.5),
          MoodKeyword('😍', 1.8),
          MoodKeyword('❤️', 1.5),
          MoodKeyword('😁', 1.5),
        ]);
    score[Mood.sad] = (score[Mood.sad] ?? 0) +
        _scoreEmojis(text, const [
          MoodKeyword('😢', 2.0),
          MoodKeyword('😭', 2.5),
          MoodKeyword('💔', 2.5),
          MoodKeyword('😞', 2.0),
          MoodKeyword('😔', 2.0),
        ]);
    score[Mood.angry] = (score[Mood.angry] ?? 0) +
        _scoreEmojis(text, const [
          MoodKeyword('😡', 2.5),
          MoodKeyword('😠', 2.5),
          MoodKeyword('🤬', 2.5),
          MoodKeyword('😤', 2.0),
        ]);
    score[Mood.anxious] = (score[Mood.anxious] ?? 0) +
        _scoreEmojis(text, const [
          MoodKeyword('😰', 2.0),
          MoodKeyword('😨', 2.0),
          MoodKeyword('😱', 2.5),
          MoodKeyword('😟', 1.8),
        ]);

    if (hasExclamation) {
      score[Mood.excited] = (score[Mood.excited] ?? 0) + 0.3;
      score[Mood.happy] = (score[Mood.happy] ?? 0) + 0.1;
    }

    final maxScore = score.values.reduce((a, b) => a > b ? a : b);
    final threshold = wordCount <= 2 ? 0.2 : 0.1;
    if (maxScore < threshold) return Mood.neutral;

    return score.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  double _scoreMoodKeywords(String text, List<MoodKeyword> keywords) {
    double score = 0;
    for (final keyword in keywords) {
      if (text.contains(keyword.phrase)) {
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

  String normalizeText(String input) {
    var text = input.toLowerCase().trim();

    // Normalize Arabic letters.
    text = text
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ٱ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي');

    // Remove Arabic diacritics.
    text = text.replaceAll(
      RegExp(r'[\u064B-\u065F\u0670]'),
      '',
    );

    // Normalize repeated characters:
    // "soooo happy" becomes "soo happy".
    text = text.replaceAll(
      RegExp(r'(.)\1{2,}'),
      r'$1$1',
    );

    // Keep Arabic, English, numbers, spaces, and apostrophes.
    text = text.replaceAll(
      RegExp(r"[^\u0600-\u06FFa-z0-9\s']"),
      ' ',
    );

    // Collapse multiple spaces.
    text = text.replaceAll(RegExp(r'\s+'), ' ');

    return text.trim();
  }
}
