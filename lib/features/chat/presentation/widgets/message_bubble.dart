import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/constants/pulse_text_styles.dart';
import 'package:pulse/features/chat/domain/entities/message_entity.dart';

class MessageBubble extends StatefulWidget {
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
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideIn;
  late final Animation<double> _scaleIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slideIn = Tween<Offset>(
      begin: Offset(widget.isMe ? 0.18 : -0.18, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _scaleIn = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moodColor = widget.message.mood.color;
    final isMe = widget.isMe;

    return FadeTransition(
      opacity: _fadeIn,
      child: SlideTransition(
        position: _slideIn,
        child: ScaleTransition(
          scale: _scaleIn,
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: GestureDetector(
            onLongPress: isMe ? widget.onLongPress : null,
            behavior: HitTestBehavior.opaque,
            child: Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.78,
                ),
                child: Container(
                  margin: EdgeInsets.only(
                    top: 3,
                    bottom: 3,
                    left: isMe ? 56 : 14,
                    right: isMe ? 14 : 56,
                  ),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          gradient: isMe
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    moodColor,
                                    moodColor.withValues(alpha: 0.78),
                                  ],
                                )
                              : null,
                          color: isMe
                              ? null
                              : PulseColors.surface.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20),
                            topRight: const Radius.circular(20),
                            bottomLeft: Radius.circular(isMe ? 20 : 6),
                            bottomRight: Radius.circular(isMe ? 6 : 20),
                          ),
                          border: isMe
                              ? null
                              : Border.all(
                                  color: moodColor.withValues(alpha: 0.32),
                                  width: 1.2,
                                ),
                          boxShadow: [
                            BoxShadow(
                              color: moodColor.withValues(alpha: 0.22),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.message.content,
                          style: PulseTextStyles.bodyMedium.copyWith(
                            color:
                                isMe ? Colors.white : PulseColors.textPrimary,
                            height: 1.32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMe ? 4 : 6,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.message.mood.emoji,
                              style: const TextStyle(fontSize: 11),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              DateFormat('HH:mm').format(widget.message.sentAt),
                              style: PulseTextStyles.labelSmall.copyWith(
                                color: PulseColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
