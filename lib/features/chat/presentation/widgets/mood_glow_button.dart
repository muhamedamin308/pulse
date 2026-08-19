import 'package:flutter/material.dart';
import 'package:pulse/core/constants/mood.dart';

class MoodGlowButton extends StatefulWidget {
  final Mood mood;
  final bool isActive;
  final VoidCallback onTap;

  const MoodGlowButton({
    super.key,
    required this.mood,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<MoodGlowButton> createState() => _MoodGlowButtonState();
}

class _MoodGlowButtonState extends State<MoodGlowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.7)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isActive) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant MoodGlowButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.isActive && widget.mood != oldWidget.mood) {
      _controller.repeat(reverse: true);
    } else if(!widget.isActive) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: widget.mood.color.withValues(alpha: .15),
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.mood.color.withValues(alpha: 0.6),
                width: 1.5,
              ),
              boxShadow: widget.isActive
                  ? [
                      BoxShadow(
                        color: widget.mood.color.withValues(alpha:
                          _glowAnimation.value,
                        ),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: Text(
                  widget.mood.emoji,
                  key: ValueKey(widget.mood),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
