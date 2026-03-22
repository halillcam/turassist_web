import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:turassist_web/firebase_options.dart';
import 'package:turassist_web/core/bindings/initial_binding.dart';
import 'package:turassist_web/core/constants/app_routes.dart';
import 'package:turassist_web/core/constants/app_strings.dart';
import 'package:turassist_web/core/theme/app_theme.dart';
import 'package:turassist_web/core/widgets/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (error) {
    throw StateError(
      'Failed to load .env. Copy .env.example to .env and fill in the Firebase values. Error: $error',
    );
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: InitialBinding(),
      home: const AuthGate(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
