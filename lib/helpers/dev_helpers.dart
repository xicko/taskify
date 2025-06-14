import 'package:flutter/foundation.dart';

mixin DevHelpers {
  void devLog(String content) {
    if (!kReleaseMode) {
      debugPrint(content);
    }
  }
}
