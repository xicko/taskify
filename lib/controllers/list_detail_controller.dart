import 'dart:convert';

import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListDetailController extends GetxController {
  static ListDetailController get to => Get.find();

  FleatherController listDetailContentController = FleatherController();
  FocusNode contentFocusNode = FocusNode();

  @override
  void onClose() {
    super.onClose();
    listDetailContentController.dispose();
    contentFocusNode.dispose();
  }

  // Method to load the list, use at widget mount initState
  Future<ParchmentDocument> loadDocument(String content) async {
    final list = content ?? 'No Content Available';

    // Try to parse JSON safely
    try {
      final decodedList = jsonDecode(list);

      // If decoding succeeds and it's a list (Delta format), return as Delta
      if (decodedList is List) {
        return ParchmentDocument.fromJson(decodedList);
      }
    } catch (e) {
      // If jsonDecode fails, assume it's plain text
    }

    // If it's plain text, wrap it in a Delta format
    return ParchmentDocument()..insert(0, list);
  }
}
