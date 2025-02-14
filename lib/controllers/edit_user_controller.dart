import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/controllers/ui_controller.dart';

class EditUserController extends GetxController {
  static EditUserController get to => Get.find();

  RxBool emailUpdateSent = false.obs;
  RxBool passwordUpdatedText = false.obs;

  // Text input controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  Future<void> fillUserEmail() async {
    final user = AuthService().supabase.auth.currentSession?.user;
    if (user != null) {
      emailController.text = AuthService().getCurrentUserEmail().toString();
    }
    debugPrint(user.toString());
  }

  Future<void> updateEmail(String newEmail) async {
    emailUpdateSent.value = false;

    // Only update email if email is changed in the textfield input
    if (emailController.text == AuthService().getCurrentUserEmail()) {
      UIController.to.getSnackbar('New email cannot be same as old email', '',
          hideMessage: true);
    } else {
      try {
        final session = AuthService().supabase.auth.currentSession;
        if (session == null) {
          throw Exception('No user session found. Please log in again.');
        }

        await AuthService()
            .supabase
            .auth
            .updateUser(UserAttributes(email: newEmail));

        await AuthService().supabase.auth.refreshSession();

        emailUpdateSent.value = true;
      } catch (e) {
        debugPrint('Error updating mail $e');
        UIController.to.getSnackbar('Error: $e', '', hideMessage: true);
        emailUpdateSent.value = false;
      }
    }
  }

  Future<void> updatePassword(BuildContext context, String newPassword) async {
    passwordUpdatedText.value = false;

    try {
      final session = AuthService().supabase.auth.currentSession;

      // for confirming currentpassword
      await AuthService().supabase.auth.signInWithPassword(
          email: AuthService().supabase.auth.currentUser?.email ?? '',
          password: currentPasswordController.text);

      if (session == null) {
        throw Exception('No user session found. Please log in again.');
      }

      await AuthService()
          .supabase
          .auth
          .updateUser(UserAttributes(password: newPassword));

      await AuthService().supabase.auth.refreshSession();

      passwordUpdatedText.value = true;
    } catch (e) {
      debugPrint('Error updating password $e');
      UIController.to.getSnackbar('Error: $e', '', hideMessage: true);
      passwordUpdatedText.value = false;
    }
  }
}
