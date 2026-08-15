import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/constants/pulse_text_styles.dart';
import 'package:pulse/features/chat/domain/entities/chat_entity.dart';

class ChatTile extends StatelessWidget {
  final ChatEntity chat;
  final String currentUserId;
  final String friendName;
  final String? friendPhotoUrl;
  final VoidCallback onTap;

  const ChatTile({
    super.key,
    required this.chat,
    required this.currentUserId,
    required this.friendName,
    this.friendPhotoUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final unread = chat.unreadCount[currentUserId] ?? 0;
    final moodColor = chat.lastMessageMood?.color ?? PulseColors.primary;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
          radius: 26,
          backgroundColor: PulseColors.surfaceVariant,
          backgroundImage:
              friendPhotoUrl != null ? NetworkImage(friendPhotoUrl!) : null,
          child: friendPhotoUrl == null
              ? Text(
                  friendName.isNotEmpty ? friendName[0].toUpperCase() : '?',
                  style: PulseTextStyles.titleMedium,
                )
              : null),
      title: Text(friendName, style: PulseTextStyles.titleMedium),
      subtitle: Row(
        children: [
          if (chat.lastMessageMood != null)
            Text(
              chat.lastMessageMood!.emoji,
              style: const TextStyle(fontSize: 12),
            ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              chat.lastMessage ?? 'Start a conversation',
              style: PulseTextStyles.bodySmall.copyWith(
                color: unread > 0 ? moodColor : PulseColors.textHint,
                fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (chat.lastMessageAt != null)
              Text(
                DateFormat('HH:mm').format(chat.lastMessageAt!),
                style: PulseTextStyles.labelSmall,
              ),
            if (unread > 0) ...[
              const SizedBox(height: 4),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: moodColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    unread > 9 ? '9+' : '$unread',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ]),
    );
  }
}
