import 'package:flutter/material.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/constants/pulse_text_styles.dart';
import 'package:pulse/features/friends/domain/entities/friend_entity.dart';

class FriendTile extends StatelessWidget {
  final FriendEntity friend;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const FriendTile({
    super.key,
    required this.friend,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PulseColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: PulseColors.surfaceVariant,
                    backgroundImage: friend.photoUrl != null
                        ? NetworkImage(friend.photoUrl!)
                        : null,
                    child: friend.photoUrl == null
                        ? Text(
                            friend.name.isNotEmpty
                                ? friend.name[0].toUpperCase()
                                : '?',
                            style: PulseTextStyles.titleMedium,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: friend.isOnline
                            ? PulseColors.online
                            : PulseColors.offline,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: PulseColors.surface,
                          width: 2,
                        ),
                        boxShadow: friend.isOnline
                            ? [
                                BoxShadow(
                                  color:
                                      PulseColors.online.withValues(alpha: 0.5),
                                  blurRadius: 4,
                                ),
                              ]
                            : [],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(friend.name, style: PulseTextStyles.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      friend.isOnline ? 'Online' : 'Offline',
                      style: PulseTextStyles.bodySmall.copyWith(
                        color: friend.isOnline
                            ? PulseColors.online
                            : PulseColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.person_remove_outlined,
                  color: PulseColors.error,
                  size: 20,
                ),
                onPressed: onRemove,
                style: IconButton.styleFrom(
                  backgroundColor: PulseColors.error.withValues(alpha: 0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
