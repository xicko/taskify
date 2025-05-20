import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    isLoggedIn.value = session != null;
    if (session != null) {
      userId.value = session.user.id;
      userEmail.value = session.user.email ?? '';
    }

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
}
