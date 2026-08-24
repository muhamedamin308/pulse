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

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: moodColor.withValues(alpha: 0.08),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: unread > 0
                  ? moodColor.withValues(alpha: 0.35)
                  : PulseColors.divider.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: unread > 0
                          ? LinearGradient(
                              colors: [
                                moodColor,
                                moodColor.withValues(alpha: 0.4),
                              ],
                            )
                          : null,
                    ),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: PulseColors.surfaceVariant,
                      backgroundImage: friendPhotoUrl != null
                          ? NetworkImage(friendPhotoUrl!)
                          : null,
                      child: friendPhotoUrl == null
                          ? Text(
                              friendName.isNotEmpty
                                  ? friendName[0].toUpperCase()
                                  : '?',
                              style: PulseTextStyles.titleMedium,
                            )
                          : null,
                    ),
                  ),
                  if (chat.lastMessageMood != null)
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: PulseColors.background,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: PulseColors.surface,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          chat.lastMessageMood!.emoji,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(friendName, style: PulseTextStyles.titleMedium),
                    const SizedBox(height: 3),
                    Text(
                      chat.lastMessage ?? 'Start a conversation',
                      style: PulseTextStyles.bodySmall.copyWith(
                        color: unread > 0
                            ? PulseColors.textPrimary.withValues(alpha: 0.85)
                            : PulseColors.textHint,
                        fontWeight:
                            unread > 0 ? FontWeight.w600 : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (chat.lastMessageAt != null)
                    Text(
                      DateFormat('HH:mm').format(chat.lastMessageAt!),
                      style: PulseTextStyles.labelSmall,
                    ),
                  const SizedBox(height: 6),
                  if (unread > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      constraints: const BoxConstraints(minWidth: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            moodColor,
                            moodColor.withValues(alpha: 0.75)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: moodColor.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          unread > 9 ? '9+' : '$unread',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
