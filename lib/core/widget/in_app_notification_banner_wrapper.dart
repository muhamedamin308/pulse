import 'package:flutter/material.dart';
import 'package:pulse/config/di/injection.dart';
import 'package:pulse/config/router/app_router.dart';
import 'package:pulse/core/services/in_app_notification_manager.dart';
import 'package:pulse/core/widget/in_app_notification_banner.dart';


class InAppNotificationBannerWrapper extends StatelessWidget {
  final String senderName;
  final String message;
  final String moodEmoji;
  final String chatId;
  final String friendId;
  final VoidCallback onDismiss;

  const InAppNotificationBannerWrapper({
    super.key,
    required this.senderName,
    required this.message,
    required this.moodEmoji,
    required this.chatId,
    required this.friendId,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return InAppNotificationBanner(
      senderName: senderName,
      message: message,
      moodEmoji: moodEmoji,
      onDismiss: onDismiss,
      onTap: () => _navigateToChat(),
    );
  }

  void _navigateToChat() {
    final router = getIt<InAppNotificationManager>().router;
    if (router == null) return;

    router.pushNamed(
      AppRoutes.chatName,
      pathParameters: {'chatId': chatId},
      queryParameters: {
        'friendName': senderName,
        'friendId': friendId,
      },
    );
  }
}
