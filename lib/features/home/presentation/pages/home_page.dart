import 'package:flutter/material.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
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
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          ChatsPage(),
          FriendsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: PulseColors.surface,
        indicatorColor: PulseColors.primary.withValues(alpha: 0.2),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(
              Icons.chat_bubble_rounded,
              color: PulseColors.primary,
            ),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline_rounded),
            selectedIcon: Icon(
              Icons.people_rounded,
              color: PulseColors.primary,
            ),
            label: 'Friends',
          ),
        ],
      ),
    );
  }
}
