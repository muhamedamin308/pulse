class PulseConstants {
  PulseConstants._();

  static const appName = 'Pulse';
  static const appTagline = 'Every message has a feeling.';

  // Firestore Collections
  static const usersCollection = 'users';
  static const chatsCollection = 'chats';
  static const messagesCollection = 'messages';
  static const groupsCollection = 'groups';
  static const friendRequestsCollection = 'friend_requests';

  // Hive Boxes
  static const userBox = 'user_box';
  static const settingsBox = 'settings_box';

  // Shared Prefs Keys
  static const isOnboardedKey = 'is_onboarded';

  // Timeouts
  static const requestTimeout = Duration(seconds: 30);

  // Pagination
  static const messagesPageSize = 30;
  static const chatsPageSize = 20;
}
