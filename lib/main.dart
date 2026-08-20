import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pulse/config/di/injection.dart';
import 'package:pulse/config/router/app_router.dart';
import 'package:pulse/core/constants/pulse_constants.dart';
import 'package:pulse/core/services/notification_service.dart';
import 'package:pulse/core/services/online_status_service.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Hive init
  await Hive.initFlutter();
  await Hive.openBox(PulseConstants.settingsBox);

  // Dependency Injection
  configureDependencies();

  // Notifications
  await getIt<NotificationService>().initialize();

  // Online status
  getIt<OnlineStatusService>().initialize();

  runApp(const PulseApp());
}

class PulseApp extends StatelessWidget {
  const PulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pulse',
      debugShowCheckedModeBanner: false,
      theme: PulseTheme.dark,
      routerConfig: appRouter,
    );
  }
}
