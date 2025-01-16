import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/controllers/list_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class BaseController extends GetxController {
  static BaseController get to => Get.find();

  // TODO
  var isOffline = false.obs;

  // Obs makes the variable observable, allowing UI to react to changes
  var currentNavIndex = 1.obs; // flag to track current navbar index

  // flag for tracking which auth screen(login signup) in me_page
  RxInt authScreen = 0.obs;

  // Method to change the current nav index
  void changePage(int index) {
    currentNavIndex.value = index;

    // Unfocusing elements(TextField) if nav index is changed
    FocusManager.instance.primaryFocus?.unfocus();

    ListController.to.isNewListModalVisible.value = false;
    ListController.to.isMySearchMode.value = false;
    ListController.to.isDiscoverSearchMode.value = false;

    // ListController.to.pagingController.refresh();
    // ListController.to.publicPagingController.refresh();

    UIController.to.listDetailPageOpen.value = false;
    AuthService().supabase.auth.refreshSession();
  }

  void switchAuthScreen(int index) {
    authScreen.value = index;
  }

  void showNewListModal() {
    ListController.to.isNewListModalVisible.value = true;
    debugPrint('shownewlist');
  }

  Future<void> openLink(String url) async {
    final Uri link = Uri.parse(url);
    if (!await launchUrl(link)) {
      debugPrint('Could not launch $url');
    }
  }
}
