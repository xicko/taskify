import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/screens/me_page.dart';

class MeNav extends StatelessWidget {
  const MeNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey('me'),
      onGenerateRoute: (settings) {
        return GetPageRoute(
          settings: settings,
          page: () => const MePage(),
        );
      },
    );
  }
}
