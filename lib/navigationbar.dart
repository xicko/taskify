import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controllers/auth_controller.dart';
import 'package:taskify/controllers/avatar_controller.dart';
import 'package:taskify/controllers/base_controller.dart';
import 'package:taskify/theme/colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NavigationBar(
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
            // When index not selected
            icon: AuthController.to.isLoggedIn.value
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      border: Border.all(
                        width: 2,
                        color: AppColors.navProfileRing(
                            Theme.of(context).brightness),
                      ),
                    ),
                    child: ClipOval(
                      child: AvatarController.to.currentBase64.value.isNotEmpty
                          ? Image.memory(
                              // If user have pfp
                              AvatarController.to.currentPic(),
                              width: 18,
                              height: 18,
                            )
                          : Image(
                              // If user has no pfp
                              image: AssetImage('assets/avatar.png'),
                              width: 18,
                              height: 18,
                            ),
                    ),
                  )
                : Icon(Icons.person_outline),
            // When index selected / active
            selectedIcon: AuthController.to.isLoggedIn.value
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      border: Border.all(
                        width: 2,
                        color: AppColors.navProfileRingSelected(
                            Theme.of(context).brightness),
                      ),
                    ),
                    child: ClipOval(
                      child: AvatarController.to.currentBase64.value.isNotEmpty
                          ? Image.memory(
                              // If user have pfp
                              AvatarController.to.currentPic(),
                              width: 18,
                              height: 18,
                            )
                          : Image(
                              // If user has no pfp
                              image: AssetImage('assets/avatar.png'),
                              width: 18,
                              height: 18,
                            ),
                    ),
                  )
                : Icon(
                    Icons.person,
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .selectedItemColor,
                  ),
            label: 'Me',
          ),

          // Obx(() => Text(AvatarController.to.hasProfilePic.value.toString()))
        ],
      ),
    );
  }
}
