import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskify/controllers/avatar_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      // Attempt to sign in with email and password
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Fetching user pfp
      await Future.delayed(Duration(milliseconds: 50));
      await AvatarController.to.fetchProfilePic();

      // Return the response if no error occurred
      return res;
    } on AuthException catch (e) {
      // Handle specific AuthException errors
      debugPrint('AuthException: $e');
      UIController.to.getSnackbar('Login error occurred.', 'Please try again.');

      rethrow;
    } catch (e) {
      // Handle any other general exceptions
      debugPrint('Error: $e');
      UIController.to
          .getSnackbar('An unexpected error occurred.', 'Please try again.');

      rethrow;
    }
  }

  Future<AuthResponse?> signUpWithEmailPassword(
      String email, String password) async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      // Fetching user pfp
      await Future.delayed(Duration(milliseconds: 50));
      await AvatarController.to.fetchProfilePic();

      return res;
    } on AuthException catch (e) {
      // Handle AuthException errors specifically
      debugPrint('AuthException: $e');
      UIController.to
          .getSnackbar('Sign-up error occurred.', 'Please try again.');
    } catch (e) {
      // Handle other types of exceptions
      debugPrint('Error: $e');
      UIController.to
          .getSnackbar('An unexpected error occurred.', 'Please try again.');
    }
    return null;
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();

    AvatarController.to.clearPic();
  }

  String? getCurrentUserEmail() {
    final session = supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  String? getCurrentUserId() {
    final session = supabase.auth.currentSession;
    final user = session?.user;
    return user?.id;
  }
}
