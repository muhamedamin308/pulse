import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/config/di/injection.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/features/friends/presentation/bloc/friends_cubit.dart';
import 'package:pulse/features/friends/presentation/pages/friends_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final _tabs = const [
    // Phase 4: replace with real ChatsPage
    _ChatsPlaceholder(),
    FriendsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FriendsCubit>(),
      child: Scaffold(
        backgroundColor: PulseColors.background,
        body: _tabs[_currentIndex],
        bottomNavigationBar: NavigationBar(
          backgroundColor: PulseColors.surface,
          indicatorColor: PulseColors.primary.withValues(alpha: 0.2),
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) =>
              setState(() => _currentIndex = index),
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
      ),
    );
  }
}

class _ChatsPlaceholder extends StatelessWidget {
  const _ChatsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Chats — Phase 4',
        style: TextStyle(color: PulseColors.textSecondary),
      ),
    );
  }
}
