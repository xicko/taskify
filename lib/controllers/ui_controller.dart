import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum OpenScreenType {
  fromTop,
  fromBottom,
  fromLeft,
  fromRight,
}

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

  void openScreen(
    BuildContext context,
    Widget child, {
    required OpenScreenType direction,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Offset begin;
          const end = Offset(0, 0);

          if (direction == OpenScreenType.fromBottom) {
            begin = Offset(0, 1);
          } else if (direction == OpenScreenType.fromTop) {
            begin = Offset(0, -1);
          } else if (direction == OpenScreenType.fromLeft) {
            begin = Offset(-1, 0);
          } else if (direction == OpenScreenType.fromRight) {
            begin = Offset(1, 0);
          } else {
            begin = Offset(0, 1);
          }

          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        pageBuilder: (context, secondaryAnimation, animation) {
          return child;
        },
      ),
    );
  }
}
