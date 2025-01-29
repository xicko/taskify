// Base screen used for navigation bar and overlays, obx listens for changes
// in the BaseController, IndexedStack displays different screens
// based on the index of currentIndex which is changed by BottomNavBar

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controllers/list_creation_controller.dart';
import 'package:taskify/navs/home_nav.dart';
import 'package:taskify/navs/discover_nav.dart';
import 'package:taskify/navs/me_nav.dart';
import 'package:taskify/widgets/discoverlist/discover_list_scrollbar.dart';
import 'package:taskify/widgets/mylist/my_list_scrollbar.dart';
import 'package:taskify/widgets/newlist_modal.dart';
import 'package:taskify/controllers/base_controller.dart';
import 'package:taskify/navigationbar.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        return;
      },
      child: KeyboardDismissOnTap(
        child: Scaffold(
          // 0px appbar for transparent status bar
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0), // Empty height
            child: AppBar(
              backgroundColor: Colors.black, // Affects the status bar color
              elevation: 0,
            ),
          ),
          body: Stack(
            children: [
              // Navbar
              Obx(
                () => IndexedStack(
                  index: BaseController.to.currentNavIndex.value,
                  children: const [
                    DiscoverNav(),
                    HomeNav(),
                    MeNav(),
                  ],
                ),
              ),

              // Modals and other overlays
              Obx(
                () => Stack(
                  children: [
                    // Add new list modal
                    AnimatedPositioned(
                      bottom:
                          ListCreationController.to.isNewListModalVisible.value
                              ? 0
                              : -screenHeight,
                      top: ListCreationController.to.isNewListModalVisible.value
                          ? 0
                          : screenHeight,
                      left: 0,
                      right: 0,
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 400),
                      child: NewListModal(),
                    ),
                  ],
                ),
              ),

              // List Scrollbars
              Positioned(
                top: screenHeight / 2 - 200,
                right: 0,
                bottom: 0,
                child: MyListScrollbar(),
              ),
              Positioned(
                top: screenHeight / 2 - 200,
                right: 0,
                bottom: 0,
                child: DiscoverListScrollbar(),
              ),
            ],
          ),
          bottomNavigationBar: const BottomNavBar(),
        ),
      ),
    );
  }
}
