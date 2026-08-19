import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/config/router/app_router.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/constants/pulse_text_styles.dart';
import 'package:pulse/features/chat/presentation/pages/chats_page.dart';
import 'package:pulse/features/friends/presentation/pages/friends_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PulseColors.background,
      appBar: AppBar(
        backgroundColor: PulseColors.background,
        elevation: 0,
        title: Text(
          _currentIndex == 0 ? 'Chats' : 'Friends',
          style: PulseTextStyles.headlineMedium,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => context.pushNamed(AppRoutes.profileName),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: PulseColors.surfaceVariant,
                backgroundImage: FirebaseAuth.instance.currentUser?.photoURL !=
                        null
                    ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                    : null,
                child: FirebaseAuth.instance.currentUser?.photoURL == null
                    ? Text(
                        FirebaseAuth.instance.currentUser?.displayName
                                    ?.isNotEmpty ==
                                true
                            ? FirebaseAuth.instance.currentUser!.displayName![0]
                                .toUpperCase()
                            : '?',
                        style: PulseTextStyles.labelLarge,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          ChatsPage(),
          FriendsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: PulseColors.surface,
        indicatorColor: PulseColors.primary.withValues(alpha: .2),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(
              Icons.chat_bubble,
              color: PulseColors.primary,
            ),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(
              Icons.people,
              color: PulseColors.primary,
            ),
            label: 'Friends',
          ),
        ],
      ),
    );
  }
}
