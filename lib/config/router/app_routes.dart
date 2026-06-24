part of 'app_router.dart';

class AppRoutes {
  AppRoutes._();

  // Splash
  static const splash = '/';
  static const splashName = 'splash';

  // Onboarding
  static const onboarding = '/onboarding';
  static const onboardingName = 'onboarding';

  // Auth — Phase 2
  static const login = '/login';
  static const loginName = 'login';
  static const register = '/register';
  static const registerName = 'register';

  // Main — Phase 3+
  static const home = '/home';
  static const homeName = 'home';
  static const chat = '/chat/:chatId';
  static const chatName = 'chat';
  static const profile = '/profile';
  static const profileName = 'profile';
  static const group = '/group/:groupId';
  static const groupName = 'group';
}
