import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/config/di/injection.dart';
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

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splashName,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: AppRoutes.onboardingName,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.loginName,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<AuthCubit>(),
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: AppRoutes.registerName,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<AuthCubit>(),
        child: const RegisterPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.homeName,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<FriendsCubit>()),
          BlocProvider(create: (_) => getIt<ChatsListCubit>()),
        ],
        child: const HomePage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.search,
      name: AppRoutes.searchName,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<SearchCubit>()),
          BlocProvider.value(value: getIt<FriendsCubit>()),
        ],
        child: const SearchPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.chat,
      name: AppRoutes.chatName,
      builder: (context, state) {
        final chatId = state.pathParameters['chatId']!;
        final friendName = state.uri.queryParameters['friendName'] ?? '';
        return BlocProvider(
          create: (_) => getIt<ChatCubit>(),
          child: ChatPage(
            chatId: chatId,
            friendName: friendName,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.timeline,
      name: AppRoutes.timelineName,
      builder: (context, state) {
        final chatId = state.pathParameters['chatId']!;
        final friendName = state.uri.queryParameters['friendName'] ?? '';
        return BlocProvider(
          create: (_) => getIt<TimelineCubit>(),
          child: TimelinePage(
            chatId: chatId,
            friendName: friendName,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: AppRoutes.profileName,
      builder: (context, state) => const ProfilePage(),
    ),
  ],
);
