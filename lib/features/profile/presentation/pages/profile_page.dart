import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/config/router/app_router.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/constants/pulse_text_styles.dart';
import 'package:pulse/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:pulse/config/di/injection.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            context.goNamed(AppRoutes.loginName);
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: PulseColors.error,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: PulseColors.background,
          appBar: AppBar(
            backgroundColor: PulseColors.background,
            elevation: 0,
            title: const Text(
              'Profile',
              style: PulseTextStyles.headlineMedium,
            ),
            centerTitle: true,
          ),
          body: FutureBuilder<DocumentSnapshot>(
            future:
                FirebaseFirestore.instance.collection('users').doc(uid).get(),
            builder: (context, snapshot) {
              final data = snapshot.data?.data() as Map<String, dynamic>?;
              final name = data?['name'] ?? 'No name';
              final email = data?['email'] ??
                  FirebaseAuth.instance.currentUser?.email ??
                  '';
              final createdAt = (data?['createdAt'] as Timestamp?)?.toDate();
              final photoUrl = data?['photoUrl'];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Hero(
                      tag: 'profile_avatar',
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: PulseColors.surfaceVariant,
                        backgroundImage:
                            photoUrl != null ? NetworkImage(photoUrl) : null,
                        child: photoUrl == null
                            ? Text(
                                name.isNotEmpty ? name[0].toUpperCase() : '?',
                                style: PulseTextStyles.displayMedium,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(name, style: PulseTextStyles.headlineLarge),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: PulseTextStyles.bodyMedium.copyWith(
                        color: PulseColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _InfoTile(
                      icon: Icons.person_outline_rounded,
                      label: 'Name',
                      value: name,
                    ),
                    const SizedBox(height: 12),
                    _InfoTile(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: email,
                    ),
                    const SizedBox(height: 12),
                    _InfoTile(
                      icon: Icons.calendar_today_outlined,
                      label: 'Member since',
                      value: createdAt != null
                          ? '${createdAt.day}/${createdAt.month}/${createdAt.year}'
                          : 'Unknown',
                    ),
                    const SizedBox(height: 40),
                    Builder(
                      builder: (context) => SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () => _showLogoutDialog(context),
                          icon: const Icon(
                            Icons.logout_rounded,
                            color: PulseColors.error,
                          ),
                          label: const Text(
                            'Log Out',
                            style: TextStyle(color: PulseColors.error),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: PulseColors.error),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: PulseColors.surface,
        title: const Text('Log Out?'),
        content: const Text(
          'Are you sure you want to log out?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthCubit>().signOut();
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: PulseColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PulseColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: PulseColors.primary, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: PulseTextStyles.labelSmall,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: PulseTextStyles.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
