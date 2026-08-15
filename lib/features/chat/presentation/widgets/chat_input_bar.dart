import 'package:flutter/material.dart';
import 'package:pulse/core/constants/mood.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/features/chat/presentation/widgets/mood_selector.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key, required this.onSend});
  final Function(String content, Mood mood, bool isMoodOverridden) onSend;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  Mood _selectedMood = Mood.neutral;
  bool _isMoodOverridden = false;
  bool _showMoodSelector = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text, _selectedMood, _isMoodOverridden);
    _controller.clear();
    setState(() {
      _selectedMood = Mood.neutral;
      _isMoodOverridden = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: PulseColors.surface,
        border: Border(
          top: BorderSide(color: PulseColors.divider, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showMoodSelector)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: MoodSelector(
                selectedMood: _selectedMood,
                onMoodSelected: (mood) {
                  setState(() {
                    _selectedMood = mood;
                    _isMoodOverridden = true;
                  });
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Row(
              children: [
                // Mood toggle button
                GestureDetector(
                  onTap: () =>
                      setState(() => _showMoodSelector = !_showMoodSelector),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _selectedMood.color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedMood.color.withValues(alpha: .5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _selectedMood.emoji,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Text field
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: PulseColors.textPrimary),
                    maxLines: 4,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(
                        color: PulseColors.textHint,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Send button
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: PulseColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
