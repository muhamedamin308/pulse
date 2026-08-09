import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/constants/pulse_text_styles.dart';
import 'package:pulse/features/friends/presentation/bloc/friends_cubit.dart';
import 'package:pulse/features/friends/presentation/widgets/friend_tile.dart';
import 'package:pulse/features/friends/presentation/widgets/suggested_user_tile.dart';

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
    context.read<FriendsCubit>().loadFriends(_currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PulseColors.background,
      appBar: AppBar(
        title: const Text('Friends'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: implement search
            },
          ),
        ],
      ),
      body: BlocBuilder<FriendsCubit, FriendsState>(
        builder: (context, state) {
          if (state is FriendsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: PulseColors.primary),
            );
          }

          if (state is FriendsError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message, style: PulseTextStyles.bodyMedium),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context
                        .read<FriendsCubit>()
                        .loadFriends(_currentUserId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is FriendsLoaded) {
            return RefreshIndicator(
              color: PulseColors.primary,
              onRefresh: () =>
                  context.read<FriendsCubit>().loadFriends(_currentUserId),
              child: CustomScrollView(
                slivers: [
                  // Friends section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        'My Friends (${state.friends.length})',
                        style: PulseTextStyles.headlineMedium,
                      ),
                    ),
                  ),
                  if (state.friends.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 24),
                        child: Text(
                          'No friends yet. Add someone below!',
                          style: PulseTextStyles.bodyMedium.copyWith(
                            color: PulseColors.textHint,
                          ),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final friend = state.friends[index];
                          return FriendTile(
                            friend: friend,
                            onRemove: () =>
                                context.read<FriendsCubit>().removeFriend(
                                      currentUserId: _currentUserId,
                                      targetUserId: friend.uid,
                                    ),
                          );
                        },
                        childCount: state.friends.length,
                      ),
                    ),

                  // Suggestions section
                  if (state.suggestions.isNotEmpty) ...[
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Text(
                          'People you may know',
                          style: PulseTextStyles.headlineMedium,
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final user = state.suggestions[index];
                          return SuggestedUserTile(
                            user: user,
                            onAdd: () => context.read<FriendsCubit>().addFriend(
                                  currentUserId: _currentUserId,
                                  targetUserId: user.uid,
                                ),
                          );
                        },
                        childCount: state.suggestions.length,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
