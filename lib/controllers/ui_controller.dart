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
  void getSnackbar(String title, String message,
      {SnackPosition snackposition = SnackPosition.BOTTOM,
      bool dismissible = true,
      bool shadows = true,
      DismissDirection dismissDirection = DismissDirection.horizontal,
      EdgeInsets margin =
          const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      Duration duration = const Duration(seconds: 3),
      Duration animationDuration = const Duration(milliseconds: 600),
      Curve forward = Curves.easeInOut,
      Curve reverse = Curves.easeInOut,
      bool hideMessage = false}) {
    Get.snackbar(
      title,
      message,
      messageText: hideMessage ? SizedBox.shrink() : null,

      borderColor: Colors.transparent,
      borderWidth: 0,
      backgroundColor: Colors.black54,
      colorText: Colors.white,

      // Top by default
      snackPosition: snackposition,

      // Dismissible by default
      isDismissible: dismissible,

      // black12 by default
      boxShadows: [
        BoxShadow(
          offset: Offset(0, 4),
          color: shadows ? Colors.black26 : Colors.transparent,
          blurRadius: 12,
          spreadRadius: 4,
        )
      ],

      borderRadius: 6,

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
