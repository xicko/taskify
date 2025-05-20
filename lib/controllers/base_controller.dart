import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/controllers/lists_controller.dart';
import 'package:taskify/controllers/list_creation_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class BaseController extends GetxController {
  static BaseController get to => Get.find();

  // TODO
  var isOffline = false.obs;

  // Obs makes the variable observable, allowing UI to react to changes
  var currentNavIndex = 1.obs; // flag to track current navbar index

  // flag for tracking which auth screen(login signup) in me_page
  RxInt authScreen = 0.obs;

  // Track network status
  RxBool hasNetwork = true.obs;
  RxList<ConnectivityResult> connectionStatus = [ConnectivityResult.none].obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> res;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      res = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint('Couldn\'t check connectivity status $e');
      return;
    }

    return _updateConnectionStatus(res);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    connectionStatus.value = result;

    if (connectionStatus.contains(ConnectivityResult.wifi) ||
        connectionStatus.contains(ConnectivityResult.mobile) ||
        connectionStatus.contains(ConnectivityResult.ethernet) ||
        connectionStatus.contains(ConnectivityResult.vpn)) {
      // Check internet with http request
      hasNetwork.value = await checkInternet();
    } else {
      hasNetwork.value = false;
    }

    debugPrint('Connectivity changed: $connectionStatus');
  }

  // HTTP Request to check actual internet connectivity
  Future<bool> checkInternet() async {
    try {
      final res = await http
          .get(Uri.parse('http://www.google.com'))
          .timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        debugPrint("Internet check: Success");
        return true;
      } else {
        debugPrint("Internet check: Failed - Status Code: ${res.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Internet check: Error - $e");
      return false;
    }
  }

  // Method to change the current nav index
  void changePage(int index) {
    currentNavIndex.value = index;

    // Unfocusing elements(TextField) if nav index is changed
    FocusManager.instance.primaryFocus?.unfocus();

    ListCreationController.to.isNewListModalVisible.value = false;
    ListsController.to.isMySearchMode.value = false;
    ListsController.to.isDiscoverSearchMode.value = false;

    UIController.to.listDetailPageOpen.value = false;
    AuthService().supabase.auth.refreshSession();
  }

  void switchAuthScreen(int index) {
    authScreen.value = index;
  }

  void showNewListModal() {
    ListCreationController.to.isNewListModalVisible.value = true;
    debugPrint('shownewlist');
  }

  Future<void> openLink(String url) async {
    final Uri link = Uri.parse(url);
    if (!await launchUrl(link)) {
      debugPrint('Could not launch $url');
    }
  }
}
