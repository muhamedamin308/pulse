part of 'app_router.dart';

class AppRoutes {
  AppRoutes._();

  // Splash
  static const splash = '/';
  static const splashName = 'splash';

  // Onboarding
  static const onboarding = '/onboarding';
  static const onboardingName = 'onboarding';

  // Auth
  static const login = '/login';
  static const loginName = 'login';
  static const register = '/register';
  static const registerName = 'register';

  // Main
  static const home = '/home';
  static const homeName = 'home';

  // Friends — Phase 3
  static const friends = '/friends';
  static const friendsName = 'friends';
  static const search = '/search';
  static const searchName = 'search';

  // Phase 4: Chat routes
  static const chat = '/chat/:chatId';
  static const chatName = 'chat';
  static const group = '/group/:groupId';
  static const groupName = 'group';
}
