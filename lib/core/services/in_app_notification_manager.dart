import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/widget/in_app_notification_banner_wrapper.dart';

@lazySingleton
class InAppNotificationManager {
  OverlayEntry? _currentEntry;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  GoRouter? router; // add this

  void show({
    required String senderName,
    required String message,
    required String moodEmoji,
    required String chatId,
    required String friendId,
  }) {
    dismiss();

    final overlay = navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    _currentEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 8,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: InAppNotificationBannerWrapper(
            senderName: senderName,
            message: message,
            moodEmoji: moodEmoji,
            chatId: chatId,
            friendId: friendId,
            onDismiss: dismiss,
          ),
        ),
      ),
    );

    overlay.insert(_currentEntry!);
  }

  void dismiss() {
    _currentEntry?.remove();
    _currentEntry = null;
  }
}
