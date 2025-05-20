import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  static ReportController get to => Get.find();

  TextEditingController reasonController = TextEditingController();
  final FocusNode reasonFocusNode = FocusNode();

  RxBool hatespeech = false.obs;
  RxBool spam = false.obs;
  RxBool impersonation = false.obs;
  RxBool scam = false.obs;
  RxString reason = ''.obs;

  @override
  void onClose() {
    reasonController.dispose();
    reasonFocusNode.dispose();
    
    super.onClose();
  }
}
