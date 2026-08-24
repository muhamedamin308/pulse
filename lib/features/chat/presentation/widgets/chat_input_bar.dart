import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:pulse/core/constants/mood.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/services/mood_detection_service.dart';
import 'package:pulse/config/di/injection.dart';
import 'package:pulse/features/chat/presentation/widgets/mood_glow_button.dart';
import 'package:pulse/features/chat/presentation/widgets/mood_selector.dart';

class ChatInputBar extends StatefulWidget {
  final Function(String content, Mood mood, bool isMoodOverridden) onSend;
  final ValueChanged<Mood>? onMoodPreviewChanged;

  const ChatInputBar({
    super.key,
    required this.onSend,
    this.onMoodPreviewChanged,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  final _moodService = getIt<MoodDetectionService>();

  Mood _currentMood = Mood.neutral;
  bool _isMoodOverridden = false;
  bool _showMoodSelector = false;

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

  void _setMood(Mood mood) {
    _currentMood = mood;
    widget.onMoodPreviewChanged?.call(mood);
  }

  void _onTextChanged() {
    setState(() {}); // keep send button / auto-label in sync with text

    if (_isMoodOverridden) return;

    final text = _controller.text;

    if (text.trim().isEmpty) {
      if (_currentMood != Mood.neutral) setState(() => _setMood(Mood.neutral));
      return;
    }

    _lastTyped = DateTime.now();
    final capturedTime = _lastTyped;

    Future.delayed(const Duration(milliseconds: 1000), () async {
      if (_lastTyped != capturedTime) return;
      if (!mounted) return;

      final mood = await _moodService.detectMood(text);
      if (!mounted) return;
      if (_isMoodOverridden) return;

      setState(() => _setMood(mood));
    });
  }

  void _onMoodManuallySelected(Mood mood) {
    setState(() {
      _isMoodOverridden = true;
      _setMood(mood);
    });
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSend(text, _currentMood, _isMoodOverridden);

    _controller.clear();
    setState(() {
      _setMood(Mood.neutral);
      _isMoodOverridden = false;
      _showMoodSelector = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _controller.text.trim().isNotEmpty;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: PulseColors.surface.withValues(alpha: 0.6),
            border: Border(
              top: BorderSide(
                color: PulseColors.divider.withValues(alpha: 0.6),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  child: ClipRect(
                    child: _showMoodSelector
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: MoodSelector(
                              selectedMood: _currentMood,
                              onMoodSelected: _onMoodManuallySelected,
                            ),
                          )
                        : const SizedBox(height: 0, width: double.infinity),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      MoodGlowButton(
                        mood: _currentMood,
                        isActive: _currentMood != Mood.neutral,
                        onTap: () => setState(
                          () => _showMoodSelector = !_showMoodSelector,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: PulseColors.surfaceVariant
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  style: const TextStyle(
                                    color: PulseColors.textPrimary,
                                    fontSize: 14,
                                  ),
                                  maxLines: 4,
                                  minLines: 1,
                                  textCapitalization:
                                      TextCapitalization.sentences,
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
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: (!_isMoodOverridden &&
                                        _currentMood != Mood.neutral &&
                                        hasText)
                                    ? Padding(
                                        key: const ValueKey('auto-label'),
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          'auto',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: _currentMood.color,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(
                                        key: ValueKey('no-label'),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _send,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutBack,
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            gradient: hasText
                                ? const LinearGradient(
                                    colors: [
                                      PulseColors.primary,
                                      PulseColors.primaryDark,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: hasText ? null : PulseColors.surfaceVariant,
                            shape: BoxShape.circle,
                            boxShadow: hasText
                                ? [
                                    BoxShadow(
                                      color: PulseColors.primary
                                          .withValues(alpha: 0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : [],
                          ),
                          child: const Icon(
                            Icons.arrow_upward_rounded,
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
          ),
        ),
      ),
    );
  }
}
