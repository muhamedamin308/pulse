import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/constants/pulse_text_styles.dart';
import 'package:pulse/features/chat/domain/entities/message_entity.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isMe;
  final VoidCallback? onLongPress;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final moodColor = message.mood.color;

    return GestureDetector(
        onLongPress: isMe ? onLongPress : null,
        child: Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
              margin: EdgeInsets.only(
                top: 4,
                bottom: 4,
                left: isMe ? 64 : 16,
                right: isMe ? 16 : 64,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isMe
                          ? moodColor.withValues(alpha: 0.08)
                          : PulseColors.surface,
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft: Radius.circular(isMe ? 18 : 4),
                          bottomRight: Radius.circular(isMe ? 4 : 18)),
                      border: isMe
                          ? null
                          : Border.all(
                              color: moodColor.withValues(alpha: 0.5),
                              width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: moodColor.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.content,
                          style: PulseTextStyles.bodyMedium.copyWith(
                              color: isMe
                                  ? Colors.white
                                  : PulseColors.textPrimary),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.mood.emoji,
                        style: const TextStyle(fontSize: 11),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        DateFormat('HH:mm').format(message.sentAt),
                        style: PulseTextStyles.labelSmall,
                      )
                    ],
                  )
                ],
              )),
        ));
  }
}
