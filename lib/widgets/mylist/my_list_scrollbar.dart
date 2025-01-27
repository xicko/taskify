import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controllers/auth_controller.dart';
import 'package:taskify/controllers/base_controller.dart';
import 'package:taskify/controllers/lists_controller.dart';
import 'package:taskify/controllers/list_creation_controller.dart';

class MyListScrollbar extends StatelessWidget {
  const MyListScrollbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: BaseController.to.currentNavIndex.value == 1,
        child: SizedBox(
          height: 300,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              // Calculate the new scroll offset based on drag movement
              final maxScrollExtent = ListsController
                  .to.listMyScrollController.position.maxScrollExtent;

              // Calculate the new offset based on the scrollbar's drag
              final deltaScroll = details.primaryDelta ?? 0.0;
              final scrollRatio =
                  maxScrollExtent / 300; // 300 is the fixed height
              final newOffset =
                  ListsController.to.listMyScrollController.offset +
                      deltaScroll * scrollRatio;

              // Ensure the offset stays within valid bounds
              ListsController.to.listMyScrollController.jumpTo(
                newOffset.clamp(
                  ListsController
                      .to.listMyScrollController.position.minScrollExtent,
                  ListsController
                      .to.listMyScrollController.position.maxScrollExtent,
                ),
              );

              // Update the scrollbar position based on the new scroll offset
              ListsController.to.myScrollbarPosition.value =
                  ListsController.to.listMyScrollController.offset /
                      maxScrollExtent;
            },
            child: Container(
              width: AuthController.to.isLoggedIn.value == false ? 0 : 29,
              height: 300, // Same as the fixed container height
              color: Colors.transparent, // Make the container transparent
              alignment: Alignment.topRight,
              child: Obx(
                () => AnimatedOpacity(
                  opacity:
                      ListCreationController.to.isNewListModalVisible.value ||
                              AuthController.to.isLoggedIn.value == false
                          ? 0
                          : 1,
                  duration: Duration(milliseconds: 250),
                  child: Container(
                    // Fixed height of the scrollbar
                    height: 50,
                    width: 10,
                    margin: EdgeInsets.only(
                      top: (ListsController.to.myScrollbarPosition.value *
                              (300 - 50))
                          // Ensure non negative
                          .clamp(0.0, double.infinity),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(46, 0, 0,
                              0), // Shadow color with some transparency
                          spreadRadius: 2, // Amount of shadow spread
                          blurRadius: 8, // Amount of blur on the shadow
                          offset: Offset(0, 2), // Shadow position offset (x, y)
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
