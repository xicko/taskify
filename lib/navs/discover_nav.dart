import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/screens/discover_page.dart';

class DiscoverNav extends StatelessWidget {
  const DiscoverNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey('discover'),
      onGenerateRoute: (settings) {
        return GetPageRoute(
          settings: settings,
          page: () => const DiscoverPage(),
        );
      },
    );
  }
}
