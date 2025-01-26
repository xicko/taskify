import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UIController extends GetxController {
  static UIController get to => Get.find();

  RxBool isSnackbarVisible = false.obs;

  // flag to track if list_details_page is open, does NOT control visibility.
  RxBool listDetailPageOpen = false.obs;

  // Login/Signup Modals
  RxBool loginVisibility = false.obs; // flag to track if login modal is visible
  RxBool signupVisibility =
      false.obs; // flag to track if signup modal is visible

  // Getx Snackbar
  void getSnackbar(
    String title,
    String message, {
    SnackPosition snackposition = SnackPosition.TOP,
    bool dismissible = true,
    bool shadows = true,
    DismissDirection dismissDirection = DismissDirection.horizontal,
    EdgeInsets margin =
        const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
    Duration duration = const Duration(seconds: 4),
    Duration animationDuration = const Duration(milliseconds: 300),
    Curve forward = Curves.easeOutQuad,
    Curve reverse = Curves.easeOutQuad,
  }) {
    Get.snackbar(
      title,
      message,

      borderColor: Colors.white,
      borderWidth: 1.5,
      backgroundColor: Colors.black38,
      colorText: Colors.white,

      // Top by default
      snackPosition: snackposition,

      // Dismissible by default
      isDismissible: dismissible,

      // black12 by default
      boxShadows: [
        BoxShadow(
          color: shadows ? Colors.black12 : Colors.transparent,
          blurRadius: 20,
          spreadRadius: 15,
        )
      ],

      // Horizontal by default
      dismissDirection: dismissDirection,

      margin: margin,

      duration: duration,
      animationDuration: animationDuration,

      forwardAnimationCurve: forward,
      reverseAnimationCurve: reverse,
    );
  }
}
