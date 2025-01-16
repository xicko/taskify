import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controllers/base_controller.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NavigationBar(
        // height: 120,
        // animationDuration: Duration(seconds: 2),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        selectedIndex: BaseController.to.currentNavIndex.value,
        onDestinationSelected: (index) => BaseController.to.changePage(index),
        destinations: [
          // index 0
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(
              Icons.explore,
              color:
                  Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            ),
            label: 'Discover',
          ),
          //Text(AuthService().getCurrentUserId().toString()),

          // index 1
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(
              Icons.assignment,
              color:
                  Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            ),
            label: "My Lists",
          ),

          // index 2
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(
              Icons.person,
              color:
                  Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            ),
            label: 'Me',
          ),
        ],
      ),
    );
  }
}
