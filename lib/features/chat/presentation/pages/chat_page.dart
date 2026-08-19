import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/config/router/app_router.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/constants/pulse_text_styles.dart';
import 'package:pulse/features/chat/presentation/bloc/chat_cubit.dart';
import 'package:pulse/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:pulse/features/chat/presentation/widgets/message_bubble.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String friendName;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.friendName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatCubit>().loadMessages(widget.chatId);
      context.read<ChatCubit>().markAsRead(
            chatId: widget.chatId,
            userId: _currentUserId,
          );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _showDeleteDialog(String messageId) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: PulseColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Delete message?',
            style: PulseTextStyles.bodyMedium.copyWith(
              color: PulseColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'This message will be removed from the conversation.',
            style: PulseTextStyles.bodyMedium.copyWith(
              color: PulseColors.textHint,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();

                context.read<ChatCubit>().deleteMessage(
                      chatId: widget.chatId,
                      messageId: messageId,
                    );
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: PulseColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PulseColors.background,
      appBar: AppBar(
        title: Text(widget.friendName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.insights_rounded),
            onPressed: () => context.pushNamed(
              AppRoutes.timelineName,
              pathParameters: {'chatId': widget.chatId},
              queryParameters: {'friendName': widget.friendName},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is ChatLoaded) {
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: PulseColors.primary,
                    ),
                  );
                }

                if (state is ChatError) {
                  return _buildErrorState(state.message);
                }

                if (state is ChatLoaded) {
                  if (state.messages.isEmpty) {
                    return _buildEmptyChatState();
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isMe = message.senderId == _currentUserId;

                      return MessageBubble(
                        message: message,
                        isMe: isMe,
                        onLongPress: () {
                          _showDeleteDialog(message.id);
                        },
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: BoxDecoration(
              color: PulseColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: ChatInputBar(
              onSend: (content, mood, isMoodOverridden) {
                context.read<ChatCubit>().sendMessage(
                      chatId: widget.chatId,
                      senderId: _currentUserId,
                      content: content,
                      mood: mood,
                      isMoodOverridden: isMoodOverridden,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChatState() {
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
                Icons.waving_hand_rounded,
                size: 36,
                color: PulseColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Start the conversation',
              textAlign: TextAlign.center,
              style: PulseTextStyles.bodyMedium.copyWith(
                color: PulseColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Send a message and share how you feel.',
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

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: PulseColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load messages',
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
          ],
        ),
      ),
    );
  }
}
