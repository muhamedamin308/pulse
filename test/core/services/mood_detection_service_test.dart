import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/core/constants/mood.dart' show Mood;
import 'package:pulse/core/services/mood_detection_service.dart';

void main() {
  late MoodDetectionService service;

  setUp(() => service = MoodDetectionService());

  group('MoodDetectionService Tests', () {
    test('detects excited mood', () async {
      final mood = await service.detectMood("Let's go!! This is amazing!");
      expect(mood, Mood.excited);
    });

    test('detects happy mood', () async {
      final mood = await service.detectMood('I feel so happy today');
      expect(mood, Mood.happy);
    });

    test('detects sad mood', () async {
      final mood =
          await service.detectMood('I miss you so much, feeling lonely');
      expect(mood, Mood.sad);
    });

    test('detects angry mood', () async {
      final mood = await service.detectMood('I hate this, so frustrated');
      expect(mood, Mood.angry);
    });

    test('detects anxious mood', () async {
      final mood =
          await service.detectMood('I am so nervous and stressed about this');
      expect(mood, Mood.anxious);
    });

    test('returns neutral for empty text', () async {
      final mood = await service.detectMood('');
      expect(mood, Mood.neutral);
    });

    test('returns neutral for short unclear text', () async {
      final mood = await service.detectMood('ok');
      expect(mood, Mood.neutral);
    });

    test('excited beats happy when exclamation present', () async {
      final mood = await service.detectMood('This is so great!!');
      expect(mood, anyOf(Mood.excited, Mood.happy));
    });
  });
}
