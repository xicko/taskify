import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/helpers/dev_helpers.dart';

class NetworkController extends GetxController with DevHelpers {
  static NetworkController get to => Get.find();

  // Network status
  RxBool hasNetwork = true.obs;
  RxList<ConnectivityResult> connectionStatus = [ConnectivityResult.none].obs;
  final Connectivity _connectivity = Connectivity();
  // ignore: unused_field
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final RxBool _initialCheckDone = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Network check
    initConnectivity();

    // Network listener
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      if (result != connectionStatus) {
        updateConnectionStatus(result);
      }
    });

    // basically useEffect with hasNetwork dep :p
    ever(hasNetwork, (hasNet) {
      _handleNetworkChange(hasNet);
    });
  }

  Future _handleNetworkChange(bool hasNet) async {
    if (_initialCheckDone.value) {
      if (hasNet) {
        UIController.to.getSnackbar(
          'Connection restored!',
          '',
          hideMessage: true,
        );
        await Future.delayed(Duration(milliseconds: 60));

        devLog('🟦 Connection restored');
      } else {
        UIController.to.getSnackbar(
          'Connection lost..',
          'Please check your internet connection.',
        );

        devLog('🟦 Connection lost');
      }
    }
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> res;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      res = await _connectivity.checkConnectivity();
      devLog('🟦 checked connectivity status');
    } on PlatformException catch (e) {
      devLog('🟦 Couldn\'t check connectivity status $e');
      return;
    }

    connectionStatus.value = res;
  }

  Future<void> updateConnectionStatus(List<ConnectivityResult> result) async {
    connectionStatus.value = result;

    // currentNavIndex.value = 0;

    if (connectionStatus.contains(ConnectivityResult.wifi) ||
        connectionStatus.contains(ConnectivityResult.mobile) ||
        connectionStatus.contains(ConnectivityResult.ethernet) ||
        connectionStatus.contains(ConnectivityResult.vpn)) {
      // Check internet with http request

      var net = await checkInternet();
      hasNetwork.value = net;
    } else {
      hasNetwork.value = false;
    }

    _initialCheckDone.value = true;

    devLog('🟦 Connectivity changed: $connectionStatus');
  }

  // HTTP Request to check actual internet connectivity
  Future<bool> checkInternet() async {
    final dio = Dio();

    try {
      final res = await dio.get('http://www.google.com');

      if (res.statusCode == 200) {
        devLog("🟦 Internet check: Success");

        return true;
      } else {
        devLog("🟦 Internet check: Failed - Status Code: ${res.statusCode}");
        return false;
      }
    } catch (e) {
      devLog("🟦 Internet check: Error - $e");
      return false;
    }
  }
}
