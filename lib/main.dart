import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskify/auth/auth_gate.dart';
import 'package:taskify/auth/auth_key.dart';
import 'package:taskify/controllers/auth_controller.dart';
import 'package:taskify/controllers/base_controller.dart';
import 'package:taskify/controllers/edit_user_controller.dart';
import 'package:taskify/controllers/list_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/theme/theme.dart';
import 'base_screen.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Supabase.initialize(
        // /lib/auth/auth_key.dart
        url: AuthKey.supabaseUrl,
        anonKey: AuthKey.supabaseAnonKey,
      );

      FlutterError.onError = (FlutterErrorDetails details) {
        // Log the error for debugging (e.g., to a remote logging service)
        debugPrint('Flutter Error: ${details.exceptionAsString()}');
      };

      // State Controllers
      Get.put<BaseController>(BaseController());
      Get.put<AuthController>(AuthController());
      Get.put<UIController>(UIController());
      Get.put<ListController>(ListController());
      Get.put<EditUserController>(EditUserController());

      // Screen orientation locked to portrait/vertical
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      runApp(MainApp());
    },
    (error, stackTrace) {
      // Log the unhandled error
      debugPrint('Unhandled Error: $error');
    },
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
      home: AuthGate(
        child: const BaseScreen(),
      ),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
