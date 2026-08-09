import 'package:flutter/material.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/constants/pulse_text_styles.dart';
import 'package:pulse/features/friends/domain/entities/friend_entity.dart';

class SuggestedUserTile extends StatelessWidget {
  final FriendEntity user;
  final VoidCallback onAdd;

  const SuggestedUserTile({
    super.key,
    required this.user,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: PulseColors.surfaceVariant,
        backgroundImage:
            user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
        child: user.photoUrl == null
            ? Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: PulseTextStyles.titleMedium,
              )
            : null,
      ),
      title: Text(user.name, style: PulseTextStyles.titleMedium),
      subtitle: Text(
        user.email,
        style: PulseTextStyles.bodySmall,
      ),
      trailing: TextButton(
        onPressed: onAdd,
        style: TextButton.styleFrom(
          foregroundColor: PulseColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: PulseColors.primary),
          ),
        ),
        child: const Text('Add'),
      ),
    );
  }
}
