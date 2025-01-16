import 'package:flutter/material.dart';

class AppColors {
  // Light
  static const Color light100black = Colors.black;
  static const Color lightScaffold = Color.fromARGB(255, 143, 210, 255);
  static const Color lightListDetailBG = Colors.white;

  static const Color lightLogoTitleTextIconColor = Colors.black87;
  static const Color lightDialogDeleteBtn = Color.fromARGB(255, 127, 15, 15);

  static const Color lightTextFieldBorderColor = Colors.black38;
  static const Color lightTextFieldFocusedBorderColor = Colors.black54;
  static const Color lightTextFieldCursorColor = Color.fromRGBO(33, 33, 33, 1);
  static const Color lightTextFieldHintTextColor = Colors.black54;

  static const Color lightAuthButtonShadow = Color.fromARGB(110, 255, 255, 255);

  // Dark
  static const Color dark100white = Colors.white;
  static const Color darkScaffold = Color.fromARGB(255, 20, 40, 53);
  static const Color darkListDetailBG = Color.fromARGB(255, 12, 27, 36);

  static const Color darkLogoTitleTextIconColor = Colors.white;
  static const Color darkDialogDeleteBtn = Color.fromARGB(255, 255, 101, 101);

  static const Color darkTextFieldBorderColor = Colors.white38;
  static const Color darkTextFieldFocusedBorderColor = Colors.white60;
  static const Color darkTextFieldCursorColor =
      Color.fromRGBO(245, 245, 245, 1);
  static const Color darkTextFieldHintTextColor = Colors.white60;

  static const Color darkAuthButtonShadow = Color.fromARGB(50, 255, 255, 255);

  // Methods
  static Color bw100(Brightness brightness) {
    return brightness == Brightness.light
        ? lightLogoTitleTextIconColor
        : darkLogoTitleTextIconColor;
  }

  static Color scaffold(Brightness brightness) {
    return brightness == Brightness.light ? lightScaffold : darkScaffold;
  }

  static Color listDetailBG(Brightness brightness) {
    return brightness == Brightness.light
        ? lightListDetailBG
        : darkListDetailBG;
  }

  static Color logoAndTitleTextIconColor(Brightness brightness) {
    return brightness == Brightness.light
        ? lightLogoTitleTextIconColor
        : darkLogoTitleTextIconColor;
  }

  static Color dialogDeleteBtn(Brightness brightness) {
    return brightness == Brightness.light
        ? lightDialogDeleteBtn
        : darkDialogDeleteBtn;
  }

  static Color textFieldBorderColor(Brightness brightness) {
    return brightness == Brightness.light
        ? lightTextFieldBorderColor
        : darkTextFieldBorderColor;
  }

  static Color textFieldFocusedBorderColor(Brightness brightness) {
    return brightness == Brightness.light
        ? lightTextFieldFocusedBorderColor
        : darkTextFieldFocusedBorderColor;
  }

  static Color textFieldCursorColor(Brightness brightness) {
    return brightness == Brightness.light
        ? lightTextFieldCursorColor
        : darkTextFieldCursorColor;
  }

  static Color textFieldHintTextColor(Brightness brightness) {
    return brightness == Brightness.light
        ? lightTextFieldHintTextColor
        : darkTextFieldHintTextColor;
  }

  static Color authButtonShadow(Brightness brightness) {
    return brightness == Brightness.light
        ? lightAuthButtonShadow
        : darkAuthButtonShadow;
  }
}
