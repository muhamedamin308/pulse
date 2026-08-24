import 'package:flutter/material.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/constants/pulse_text_styles.dart';
import 'package:pulse/features/friends/domain/entities/friend_entity.dart';

class SuggestedUserTile extends StatefulWidget {
  final FriendEntity user;
  final VoidCallback onAdd;

  const SuggestedUserTile({
    super.key,
    required this.user,
    required this.onAdd,
  });

  @override
  State<SuggestedUserTile> createState() => _SuggestedUserTileState();
}

class _SuggestedUserTileState extends State<SuggestedUserTile>
    with SingleTickerProviderStateMixin {
  bool _added = false;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleAdd() async {
    widget.onAdd();
    setState(() => _added = true);
    await _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: PulseColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: PulseColors.surfaceVariant,
              backgroundImage: widget.user.photoUrl != null
                  ? NetworkImage(widget.user.photoUrl!)
                  : null,
              child: widget.user.photoUrl == null
                  ? Text(
                      widget.user.name.isNotEmpty
                          ? widget.user.name[0].toUpperCase()
                          : '?',
                      style: PulseTextStyles.titleMedium,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.name,
                    style: PulseTextStyles.titleMedium,
                  ),
                  Text(
                    widget.user.email,
                    style: PulseTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _added
                  ? Container(
                      key: const ValueKey('added'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: PulseColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: PulseColors.success.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_rounded,
                            size: 14,
                            color: PulseColors.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Added',
                            style: PulseTextStyles.labelSmall.copyWith(
                              color: PulseColors.success,
                            ),
                          ),
                        ],
                      ),
                    )
                  : TextButton(
                      key: const ValueKey('add'),
                      onPressed: _handleAdd,
                      style: TextButton.styleFrom(
                        foregroundColor: PulseColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                            color: PulseColors.primary,
                          ),
                        ),
                      ),
                      child: const Text('Add'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
