import 'package:flutter/material.dart';
import 'package:pulse/core/constants/mood.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/services/mood_detection_service.dart';
import 'package:pulse/config/di/injection.dart';
import 'package:pulse/features/chat/presentation/widgets/mood_glow_button.dart';
import 'package:pulse/features/chat/presentation/widgets/mood_selector.dart';

class ChatInputBar extends StatefulWidget {
  final Function(String content, Mood mood, bool isMoodOverridden) onSend;

  const ChatInputBar({super.key, required this.onSend});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  final _moodService = getIt<MoodDetectionService>();

  Mood _currentMood = Mood.neutral;
  bool _isMoodOverridden = false;
  bool _showMoodSelector = false;

  // Debounce timer
  DateTime? _lastTyped;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    // Don't auto-detect if user manually picked a mood
    if (_isMoodOverridden) return;

    final text = _controller.text;

    if (text.trim().isEmpty) {
      setState(() => _currentMood = Mood.neutral);
      return;
    }

    // Debounce — wait 1s after user stops typing before calling Gemini API
    _lastTyped = DateTime.now();
    final capturedTime = _lastTyped;

    Future.delayed(const Duration(milliseconds: 1000), () async {
      if (_lastTyped != capturedTime) return; // user kept typing
      if (!mounted) return;

      final mood = await _moodService.detectMood(text);
      if (!mounted) return;
      if (_isMoodOverridden) return;

      setState(() => _currentMood = mood);
    });
  }

  void _onMoodManuallySelected(Mood mood) {
    setState(() {
      _currentMood = mood;
      _isMoodOverridden = true;
    });
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSend(text, _currentMood, _isMoodOverridden);

    _controller.clear();
    setState(() {
      _currentMood = Mood.neutral;
      _isMoodOverridden = false;
      _showMoodSelector = false;
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
                selectedMood: _currentMood,
                onMoodSelected: _onMoodManuallySelected,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Row(
              children: [
                // Mood button
                MoodGlowButton(
                  mood: _currentMood,
                  isActive: _currentMood != Mood.neutral,
                  onTap: () => setState(
                    () => _showMoodSelector = !_showMoodSelector,
                  ),
                ),
                const SizedBox(width: 8),

                // Auto label
                if (!_isMoodOverridden &&
                    _currentMood != Mood.neutral &&
                    _controller.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      'auto',
                      style: TextStyle(
                        fontSize: 10,
                        color: _currentMood.color,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),

                // Text field
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(
                      color: PulseColors.textPrimary,
                      fontSize: 14,
                    ),
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
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _controller.text.trim().isEmpty
                          ? PulseColors.surfaceVariant
                          : PulseColors.primary,
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
