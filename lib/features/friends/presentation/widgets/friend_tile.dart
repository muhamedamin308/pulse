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
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: PulseColors.surfaceVariant,
            backgroundImage:
                friend.photoUrl != null ? NetworkImage(friend.photoUrl!) : null,
            child: friend.photoUrl == null
                ? Text(
                    friend.name.isNotEmpty ? friend.name[0].toUpperCase() : '?',
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
                color:
                    friend.isOnline ? PulseColors.online : PulseColors.offline,
                shape: BoxShape.circle,
                border: Border.all(color: PulseColors.background, width: 2),
              ),
            ),
          ),
        ],
      ),
      title: Text(friend.name, style: PulseTextStyles.titleMedium),
      subtitle: Text(
        friend.isOnline ? 'Online' : 'Offline',
        style: PulseTextStyles.bodySmall.copyWith(
          color: friend.isOnline ? PulseColors.online : PulseColors.textHint,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.person_remove_outlined,
            color: PulseColors.error, size: 20),
        onPressed: onRemove,
      ),
    );
  }
}
