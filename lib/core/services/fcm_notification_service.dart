import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:pulse/core/constants/pulse_constants.dart';
import 'package:pulse/core/constants/mood.dart';

@lazySingleton
class FcmNotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const _fcmScope = 'https://www.googleapis.com/auth/firebase.messaging';

  final Map<String, String> _moodEmojis = {
    'happy': '😊',
    'sad': '😢',
    'angry': '😠',
    'anxious': '😰',
    'excited': '🤩',
    'neutral': '😐',
  };

  Future<String?> _getAccessToken() async {
    try {
      final jsonStr =
          await rootBundle.loadString('assets/service_account.json');
      final credentials =
          ServiceAccountCredentials.fromJson(jsonDecode(jsonStr));
      final client = await clientViaServiceAccount(credentials, [_fcmScope]);
      final token = client.credentials.accessToken.data;
      client.close();
      return token;
    } catch (e, st) {
      debugPrint('❌ FCM access token error: $e');
      debugPrint('$st');
      return null;
    }
  }

  Future<void> sendMessageNotification({
    required String recipientId,
    required String senderName,
    required String content,
    required String chatId,
    required String senderId,
    required Mood mood,
  }) async {
    try {
      // Get recipient FCM token
      final recipientDoc = await _firestore
          .collection(PulseConstants.usersCollection)
          .doc(recipientId)
          .get();
      if (!recipientDoc.exists) {
        debugPrint('❌ recipient doc missing');
        return;
      }

      final fcmToken = recipientDoc.data()?['fcmToken'] as String?;
      if (fcmToken == null || fcmToken.isEmpty) {
        debugPrint('❌ no fcmToken for $recipientId');
        return;
      }

      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        debugPrint('❌ no access token');
        return;
      }

      final emoji = _moodEmojis[mood.value] ?? '😐';
      final body =
          content.length > 50 ? '${content.substring(0, 50)}...' : content;

      final response = await http.post(
        Uri.parse(
          'https://fcm.googleapis.com/v1/projects/pulse-3c078/messages:send',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'message': {
            'token': fcmToken,
            'notification': {
              'title': '$senderName $emoji',
              'body': body,
            },
            'data': {
              'chatId': chatId,
              'senderId': senderId,
              'friendName': senderName,
              'type': 'new_message',
            },
            'android': {
              'priority': 'high',
              'notification': {
                'channel_id': 'pulse_channel',
                'sound': 'default',
              },
            },
          },
        }),
      );
      debugPrint('FCM status: ${response.statusCode} — ${response.body}');
    } catch (e, st) {
      debugPrint('❌ FCM send error: $e');
      debugPrint('$st');
    }
  }
}
