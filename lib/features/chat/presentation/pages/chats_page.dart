import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/config/router/app_router.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/constants/pulse_text_styles.dart';
import 'package:pulse/features/chat/presentation/bloc/chats_list_cubit.dart';
import 'package:pulse/features/chat/presentation/widgets/chat_tile.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatsListCubit>().loadChats(_currentUserId);
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
          'Chats',
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
              icon: const Icon(Icons.edit_rounded),
              onPressed: () {
                context.pushNamed(AppRoutes.searchName);
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<ChatsListCubit, ChatsListState>(
        builder: (context, state) {
          if (state is ChatsListLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: PulseColors.primary,
              ),
            );
          }

          if (state is ChatsListError) {
            return _buildErrorState(
              message: state.message,
              onRetry: () {
                context.read<ChatsListCubit>().loadChats(_currentUserId);
              },
            );
          }

          if (state is ChatsListLoaded) {
            if (state.chats.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              color: PulseColors.primary,
              backgroundColor: PulseColors.surface,
              onRefresh: () =>
                  context.read<ChatsListCubit>().loadChats(_currentUserId),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: state.chats.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final chat = state.chats[index];

                  final friendId = chat.participantIds.firstWhere(
                    (id) => id != _currentUserId,
                    orElse: () => '',
                  );

                  if (friendId.isEmpty) return const SizedBox.shrink();

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(friendId)
                        .get(),
                    builder: (context, snapshot) {
                      final data =
                          snapshot.data?.data() as Map<String, dynamic>?;
                      final friendName = data?['name'] ?? 'Unknown';
                      final friendPhotoUrl = data?['photoUrl'] as String?;

                      return Container(
                        decoration: BoxDecoration(
                          color: PulseColors.surface,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ChatTile(
                          chat: chat,
                          currentUserId: _currentUserId,
                          friendName: friendName,
                          friendPhotoUrl: friendPhotoUrl,
                          onTap: () {
                            context.pushNamed(
                              AppRoutes.chatName,
                              pathParameters: {'chatId': chat.id},
                              queryParameters: {
                                'friendName': friendName,
                                'friendId': friendId, // add this
                              },
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: PulseColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 36,
                color: PulseColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No chats yet',
              style: PulseTextStyles.bodyMedium.copyWith(
                color: PulseColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Go to Friends and start a conversation.',
              textAlign: TextAlign.center,
              style: PulseTextStyles.bodyMedium.copyWith(
                color: PulseColors.textHint,
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
            const Icon(
              Icons.cloud_off_rounded,
              size: 52,
              color: PulseColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load chats',
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
            const SizedBox(height: 16),
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
