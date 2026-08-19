import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/constants/pulse_constants.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message: ${message.messageId}');
}

@lazySingleton
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final settings = await _messaging.requestPermission(
        alert: true, badge: true, sound: true, provisional: false);

    debugPrint('Notification permission: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      await _saveToken();
    }

    _messaging.onTokenRefresh.listen(_updateToken);

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  Future<void> _saveToken() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final token = await _messaging.getToken();
    if (token == null) return;

    await _firestore
        .collection(PulseConstants.usersCollection)
        .doc(uid)
        .update({'fcmToken': token});

    debugPrint('FCM token saved: $token');
  }

  Future<void> _updateToken(String token) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore
        .collection(PulseConstants.usersCollection)
        .doc(uid)
        .update({'fcmToken': token});
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Forground message: ${message.notification?.title}');
    // phase 7 step 3
  }

  void _handleNotificationTap(RemoteMessage message) {
    final chatId = message.data['chatId'];
    // final friendName = message.data['friendName'] ?? '';
    debugPrint('Notification tapped - chatId: $chatId');
    // Navigation handled via navigatorKey in phase 7 step 3
  }

  Future<void> deleteToken() async {
    await _messaging.deleteToken();
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore
        .collection(PulseConstants.usersCollection)
        .doc(uid)
        .update({
      'fcmToken': FieldValue.delete(),
    });
  }
}
