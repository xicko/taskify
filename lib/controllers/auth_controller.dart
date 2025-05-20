import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskify/controllers/avatar_controller.dart';
import 'package:taskify/controllers/list_selection_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // flag to track if user is currently logged in
  RxBool isLoggedIn = false.obs;

  RxString userId = ''.obs;
  RxString userEmail = ''.obs;

  // track if email should be remembered
  RxBool rememberEmailChecked = false.obs;

  // Text Controllers for login inputs
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  // FocusNodes for login inputs
  final FocusNode loginEmailFocusNode = FocusNode();
  final FocusNode loginPasswordFocusNode = FocusNode();

  // Text Controllers for login inputs
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupPasswordController = TextEditingController();
  final TextEditingController signupConfirmPasswordController = TextEditingController();
  // FocusNodes for login inputs
  final FocusNode signupEmailFocusNode = FocusNode();
  final FocusNode signupPasswordFocusNode = FocusNode();
  final FocusNode signupConfirmPasswordFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();

    _initializeAuthState();

    restoreRememberEmail();
  }

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    loginEmailFocusNode.dispose();
    loginPasswordFocusNode.dispose();

    signupEmailController.dispose();
    signupPasswordController.dispose();
    signupConfirmPasswordController.dispose();
    signupEmailFocusNode.dispose();
    signupPasswordController.dispose();
    signupConfirmPasswordController.dispose();

    super.onClose();
  }

  Future<void> _initializeAuthState() async {
    final session = _supabaseClient.auth.currentSession;
    // initial check
    isLoggedIn.value = session != null;
    if (session != null) {
      userId.value = session.user.id;
      userEmail.value = session.user.email ?? '';
    }

    // auth listener
    _supabaseClient.auth.onAuthStateChange.listen((event) {
      isLoggedIn.value = event.session != null;
      if (event.session != null) {
        userId.value = session?.user.id ?? '';
        userEmail.value = session?.user.email ?? '';
      }
    });
  }

  // sign out func
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
    isLoggedIn.value = false;
    UIController.to.getSnackbar('Signed out', '', hideMessage: true);

    // Clear profile picture cache on signout
    AvatarController.to.clearPic();

    // Close list selectionbar if visible
    ListSelectionController.to.closeSelectionBar();
  }

  void restoreRememberEmail() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    bool? value = localStorage.getBool('isRememberEmail');
    String? emailVal = localStorage.getString('rememberEmail');

    if (value != null && emailVal != null) {
      rememberEmailChecked.value = value;
      loginEmailController.text = emailVal;
    }
  }

  void handleRememberEmail(bool? shouldRemember) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    if (shouldRemember != null && loginEmailController.text != '') {
      rememberEmailChecked.value = shouldRemember;
      localStorage.setBool('isRememberEmail', shouldRemember);

      if (shouldRemember && loginEmailController.text != '') {
        localStorage.setString('rememberEmail', loginEmailController.text);
        debugPrint('Saved email - handleRememberEmail');
      } else {
        localStorage.setString('rememberEmail', '');
      }
    }
  }

  // void onLoginInputChange(String val) async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();

  //   if (rememberEmailChecked.value) {
  //     if (val != '') {
  //       localStorage.setString('rememberEmail', loginEmailController.text);
  //     }
  //   }
  // }
}
