import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/config/di/injection.dart';
import 'package:pulse/core/services/in_app_notification_manager.dart';
import 'package:pulse/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:pulse/features/auth/presentation/pages/login_page.dart';
import 'package:pulse/features/auth/presentation/pages/register_page.dart';
import 'package:pulse/features/chat/presentation/bloc/chat_cubit.dart';
import 'package:pulse/features/chat/presentation/bloc/chats_list_cubit.dart';
import 'package:pulse/features/chat/presentation/pages/chat_page.dart';
import 'package:pulse/features/friends/presentation/bloc/friends_cubit.dart';
import 'package:pulse/features/friends/presentation/bloc/search_cubit.dart';
import 'package:pulse/features/friends/presentation/pages/search_page.dart';
import 'package:pulse/features/home/presentation/pages/home_page.dart';
import 'package:pulse/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:pulse/features/profile/presentation/pages/profile_page.dart';
import 'package:pulse/features/splash/presentation/pages/splash_page.dart';
import 'package:pulse/features/timeline/presentation/bloc/timeline_cubit.dart';
import 'package:pulse/features/timeline/presentation/page/timeline_page.dart';

part 'app_routes.dart';

CustomTransitionPage _fadePage(Widget child) => CustomTransitionPage(
    child: child,
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
    transitionDuration: const Duration(milliseconds: 250));

CustomTransitionPage _slidePage(Widget child) => CustomTransitionPage(
      child: child,
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        )),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 300),
    );

CustomTransitionPage _scaleAndFadePage(Widget child) => CustomTransitionPage(
      child: child,
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );

final appRouter = GoRouter(
  navigatorKey: getIt<InAppNotificationManager>().navigatorKey,
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splashName,
      pageBuilder: (_, __) => _fadePage(const SplashPage()),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: AppRoutes.onboardingName,
      pageBuilder: (_, __) => _fadePage(const OnboardingPage()),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.loginName,
      pageBuilder: (_, __) => _fadePage(
        BlocProvider(
          create: (_) => getIt<AuthCubit>(),
          child: const LoginPage(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: AppRoutes.registerName,
      pageBuilder: (_, __) => _slidePage(
        BlocProvider(
          create: (_) => getIt<AuthCubit>(),
          child: const RegisterPage(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.homeName,
      pageBuilder: (_, __) => _fadePage(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<FriendsCubit>()),
            BlocProvider(create: (_) => getIt<ChatsListCubit>()),
          ],
          child: const HomePage(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.search,
      name: AppRoutes.searchName,
      pageBuilder: (_, __) => _slidePage(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<SearchCubit>()),
            BlocProvider.value(value: getIt<FriendsCubit>()),
          ],
          child: const SearchPage(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: AppRoutes.profileName,
      pageBuilder: (_, __) => _scaleAndFadePage(const ProfilePage()),
    ),
    GoRoute(
      path: AppRoutes.chat,
      name: AppRoutes.chatName,
      pageBuilder: (context, state) {
        final chatId = state.pathParameters['chatId']!;
        final friendName = state.uri.queryParameters['friendName'] ?? '';
        final friendId = state.uri.queryParameters['friendId'] ?? '';
        return _slidePage(
          BlocProvider(
            create: (_) => getIt<ChatCubit>(),
            child: ChatPage(
              chatId: chatId,
              friendName: friendName,
              friendId: friendId,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.timeline,
      name: AppRoutes.timelineName,
      pageBuilder: (context, state) {
        final chatId = state.pathParameters['chatId']!;
        final friendName = state.uri.queryParameters['friendName'] ?? '';
        return _scaleAndFadePage(
          BlocProvider(
            create: (_) => getIt<TimelineCubit>(),
            child: TimelinePage(
              chatId: chatId,
              friendName: friendName,
            ),
          ),
        );
      },
    ),
  ],
);

void initRouter() {
  getIt<InAppNotificationManager>().router = appRouter;
}
