import 'package:flutter/material.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/theme/colors.dart';

class CustomSnackBar {
  static final CustomSnackBar _instance = CustomSnackBar._internal();

  factory CustomSnackBar(BuildContext context) {
    _instance.context = context;
    return _instance;
  }

  CustomSnackBar._internal();

  late BuildContext context;

  void show(String message, {int? duration}) {
    // prevent multiple snackbars being called when spammed
    if (UIController.to.isSnackbarVisible.value) return;

    // snackbar visible while _showCustomSnackBar is called
    UIController.to.isSnackbarVisible.value = true;

    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.fixed,
              duration: Duration(milliseconds: duration ?? 1300),
              backgroundColor:
                  AppColors.listDetailBG(Theme.of(context).brightness),
              content: Center(
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w500,
                    color: AppColors.bw100(Theme.of(context).brightness),
                  ),
                ),
              ),
            ),
          )
          .closed
          .then(
        (_) {
          // resetting the flag after the snackbar disappears
          UIController.to.isSnackbarVisible.value = false;
        },
      );
    }
  }
}
