import 'dart:async';
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

  @override
  void onInit() {
    super.onInit();
    _initializeAuthState();
  }

  Future<void> _initializeAuthState() async {
    final session = _supabaseClient.auth.currentSession;
    isLoggedIn.value = session != null;

    _supabaseClient.auth.onAuthStateChange.listen((event) {
      isLoggedIn.value = event.session != null;
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
