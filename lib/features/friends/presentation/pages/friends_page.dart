import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/config/router/app_router.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/constants/pulse_text_styles.dart';
import 'package:pulse/features/friends/presentation/bloc/friends_cubit.dart';
import 'package:pulse/features/friends/presentation/widgets/friend_tile.dart';
import 'package:pulse/features/friends/presentation/widgets/suggested_user_tile.dart';
import 'package:pulse/config/di/injection.dart';
import 'package:pulse/features/chat/domain/usecases/create_chat_usecase.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FriendsCubit>().loadFriends(_currentUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PulseColors.background,
      appBar: AppBar(
        backgroundColor: PulseColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 20,
        title: Text(
          'Friends',
          style: PulseTextStyles.bodyMedium.copyWith(
            color: PulseColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: PulseColors.surface,
                foregroundColor: PulseColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.search_rounded),
              onPressed: () {
                context.pushNamed(AppRoutes.searchName);
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<FriendsCubit, FriendsState>(
        builder: (context, state) {
          if (state is FriendsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: PulseColors.primary,
              ),
            );
          }

          if (state is FriendsError) {
            return _buildErrorState(
              message: state.message,
              onRetry: () {
                context.read<FriendsCubit>().loadFriends(_currentUserId);
              },
            );
          }

          if (state is FriendsLoaded) {
            return RefreshIndicator(
              color: PulseColors.primary,
              backgroundColor: PulseColors.surface,
              onRefresh: () {
                return context.read<FriendsCubit>().loadFriends(_currentUserId);
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      child: Text(
                        'Stay connected with the people who matter.',
                        style: PulseTextStyles.bodyMedium.copyWith(
                          color: PulseColors.textHint,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _buildSectionHeader(
                      title: 'My Friends',
                      count: state.friends.length,
                    ),
                  ),
                  if (state.friends.isEmpty)
                    SliverToBoxAdapter(
                      child: _buildEmptyState(
                        icon: Icons.people_outline_rounded,
                        title: 'No friends yet',
                        message:
                            'Search for people and start building your circle.',
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList.separated(
                        itemCount: state.friends.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final friend = state.friends[index];

                          return FriendTile(
                            friend: friend,
                            onTap: () async {
                              final chatId =
                                  await getIt<CreateChatUseCase>().execute(
                                currentUserId: _currentUserId,
                                targetUserId: friend.uid,
                              );
                              if (context.mounted) {
                                context.pushNamed(
                                  AppRoutes.chatName,
                                  pathParameters: {'chatId': chatId},
                                  queryParameters: {'friendName': friend.name},
                                );
                              }
                            },
                            onRemove: () =>
                                context.read<FriendsCubit>().removeFriend(
                                      currentUserId: _currentUserId,
                                      targetUserId: friend.uid,
                                    ),
                          );
                        },
                      ),
                    ),
                  if (state.suggestions.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
                        child: Text(
                          'People you may know',
                          style: PulseTextStyles.headlineMedium.copyWith(
                            color: PulseColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                      sliver: SliverList.separated(
                        itemCount: state.suggestions.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final user = state.suggestions[index];

                          return SuggestedUserTile(
                            user: user,
                            onAdd: () {
                              context.read<FriendsCubit>().addFriend(
                                    currentUserId: _currentUserId,
                                    targetUserId: user.uid,
                                  );
                            },
                          );
                        },
                      ),
                    ),
                  ] else
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 28),
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required int count,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: [
          Text(
            title,
            style: PulseTextStyles.headlineMedium.copyWith(
              color: PulseColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: PulseColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: PulseTextStyles.bodyMedium.copyWith(
                color: PulseColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: PulseColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: PulseColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: PulseColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: PulseTextStyles.bodyMedium.copyWith(
                color: PulseColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: PulseTextStyles.bodyMedium.copyWith(
                color: PulseColors.textHint,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: PulseColors.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 32,
                color: PulseColors.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load friends',
              textAlign: TextAlign.center,
              style: PulseTextStyles.bodyMedium.copyWith(
                color: PulseColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: PulseTextStyles.bodyMedium.copyWith(
                color: PulseColors.textHint,
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: TextButton.styleFrom(
                foregroundColor: PulseColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
