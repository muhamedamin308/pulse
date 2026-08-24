import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/config/router/app_router.dart';
import 'package:pulse/core/constants/mood.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/constants/pulse_text_styles.dart';
import 'package:pulse/features/chat/presentation/bloc/chat_cubit.dart';
import 'package:pulse/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:pulse/features/chat/presentation/widgets/date_separator.dart';
import 'package:pulse/features/chat/presentation/widgets/message_bubble.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String friendName;
  final String friendId;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.friendName,
    required this.friendId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final _scrollController = ScrollController();
  bool _showScrollFab = false;

  // Ambient mood: whichever the user is currently typing takes priority,
  // otherwise falls back to the mood of the last message in the thread.
  Mood _typingMood = Mood.neutral;
  Mood _lastMessageMood = Mood.neutral;

  Mood get _ambientMood =>
      _typingMood != Mood.neutral ? _typingMood : _lastMessageMood;

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadMessages(widget.chatId);
    context.read<ChatCubit>().markAsRead(
          chatId: widget.chatId,
          userId: _currentUserId,
        );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final isAtBottom = _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100;
    if (_showScrollFab == isAtBottom) {
      setState(() => _showScrollFab = !isAtBottom);
    }
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

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final diff = now.difference(lastSeen);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: PulseColors.background,
      appBar: _GlassAppBar(
        friendId: widget.friendId,
        friendName: widget.friendName,
        chatId: widget.chatId,
        formatLastSeen: _formatLastSeen,
      ),
      body: Stack(
        children: [
          // Ambient mood-reactive background
          Positioned.fill(
            child: TweenAnimationBuilder<Color?>(
              tween: ColorTween(
                begin: PulseColors.background,
                end: _ambientMood.color,
              ),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOut,
              builder: (context, color, child) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -1.4),
                      radius: 1.8,
                      colors: [
                        (color ?? PulseColors.background)
                            .withValues(alpha: 0.22),
                        PulseColors.background,
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // const SizedBox(height: kToolbarHeight + 8),
                Expanded(
                  child: BlocConsumer<ChatCubit, ChatState>(
                    listener: (context, state) {
                      if (state is ChatLoaded) {
                        _scrollToBottom();
                        if (state.messages.isNotEmpty) {
                          final mood = state.messages.last.mood;
                          if (mood != _lastMessageMood) {
                            setState(() => _lastMessageMood = mood);
                          }
                        }
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
                        return Center(
                          child: Text(
                            state.message,
                            style: PulseTextStyles.bodyMedium
                                .copyWith(color: PulseColors.textHint),
                          ),
                        );
                      }

                      if (state is ChatLoaded) {
                        if (state.messages.isEmpty) {
                          return Center(
                            child: Text(
                              'Say hello! 👋',
                              style: PulseTextStyles.bodyMedium
                                  .copyWith(color: PulseColors.textHint),
                            ),
                          );
                        }

                        return Stack(
                          children: [
                            ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              itemCount: state.messages.length,
                              itemBuilder: (context, index) {
                                final message = state.messages[index];
                                final isMe = message.senderId == _currentUserId;

                                Widget? separator;
                                if (index == 0) {
                                  separator =
                                      DateSeparator(date: message.sentAt);
                                } else {
                                  final prev = state.messages[index - 1];
                                  final prevDate = DateTime(
                                    prev.sentAt.year,
                                    prev.sentAt.month,
                                    prev.sentAt.day,
                                  );
                                  final currDate = DateTime(
                                    message.sentAt.year,
                                    message.sentAt.month,
                                    message.sentAt.day,
                                  );
                                  if (currDate != prevDate) {
                                    separator =
                                        DateSeparator(date: message.sentAt);
                                  }
                                }

                                return Column(
                                  children: [
                                    if (separator != null) separator,
                                    MessageBubble(
                                      message: message,
                                      isMe: isMe,
                                      onLongPress: () =>
                                          _showDeleteDialog(message.id),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Positioned(
                              bottom: 12,
                              right: 12,
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 200),
                                scale: _showScrollFab ? 1 : 0,
                                curve: Curves.easeOutBack,
                                child: GestureDetector(
                                  onTap: _scrollToBottom,
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: PulseColors.primary,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: PulseColors.primary
                                              .withValues(alpha: 0.4),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
                ChatInputBar(
                  onMoodPreviewChanged: (mood) {
                    if (mood != _typingMood) {
                      setState(() => _typingMood = mood);
                    }
                  },
                  onSend: (content, mood, isMoodOverridden) {
                    context.read<ChatCubit>().sendMessage(
                          chatId: widget.chatId,
                          senderId: _currentUserId,
                          content: content,
                          mood: mood,
                          isMoodOverridden: isMoodOverridden,
                        );
                    setState(() => _typingMood = Mood.neutral);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String friendId;
  final String friendName;
  final String chatId;
  final String Function(DateTime) formatLastSeen;

  const _GlassAppBar({
    required this.friendId,
    required this.friendName,
    required this.chatId,
    required this.formatLastSeen,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(friendId)
                .snapshots(),
            builder: (context, snapshot) {
              final data = snapshot.data?.data() as Map<String, dynamic>?;
              final isOnline = data?['isOnline'] ?? false;
              final lastSeen = (data?['lastSeen'] as Timestamp?)?.toDate();
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    friendName,
                    style: PulseTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: PulseColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isOnline)
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: const BoxDecoration(
                            color: PulseColors.online,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Text(
                        isOnline
                            ? 'Online'
                            : lastSeen != null
                                ? 'Last seen ${formatLastSeen(lastSeen)}'
                                : 'Offline',
                        style: TextStyle(
                          fontSize: 12,
                          color: isOnline
                              ? PulseColors.online
                              : PulseColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.insights_rounded),
              color: PulseColors.textPrimary,
              onPressed: () => context.pushNamed(
                AppRoutes.timelineName,
                pathParameters: {'chatId': chatId},
                queryParameters: {'friendName': friendName},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
