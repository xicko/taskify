import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controllers/base_controller.dart';
import 'package:taskify/controllers/list_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/widgets/abouttaskify.dart';
import 'package:taskify/theme/colors.dart';

class LogoAndTitle extends StatelessWidget {
  const LogoAndTitle({super.key});

  @override
  Widget build(BuildContext context) {
    // getting user's device screen height/width
    double screenHeight = MediaQuery.of(context).size.height;

    return Obx(
      () => AnimatedOpacity(
        opacity: ListController.to.isNewListModalVisible.value ||
                UIController.to.listDetailPageOpen.value
            ? 0
            : 1,
        duration: Duration(milliseconds: 400),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              spacing: 10,
              children: [
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor:
                          AppColors.listDetailBG(Theme.of(context).brightness),
                      isScrollControlled: true,
                      showDragHandle: true,
                      constraints:
                          BoxConstraints(maxHeight: screenHeight * 0.7),
                      context: context,
                      builder: (BuildContext context) {
                        return AboutTaskify();
                      },
                    );
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Image(
                    image: AssetImage('assets/logo1500white.png'),
                    width: 60,
                    height: 60,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Taskify',
                      style: TextStyle(
                          fontSize: 24,
                          color: AppColors.logoAndTitleTextIconColor(
                              Theme.of(context).brightness),
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      BaseController.to.currentNavIndex.value == 1
                          ? 'My lists'
                          : 'Community lists',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.bw100(Theme.of(context).brightness),
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor:
                      AppColors.listDetailBG(Theme.of(context).brightness),
                  isScrollControlled: true,
                  showDragHandle: true,
                  constraints: BoxConstraints(maxHeight: screenHeight * 0.7),
                  context: context,
                  builder: (BuildContext context) {
                    return AboutTaskify();
                  },
                );
              },
              icon: Icon(
                Icons.info_outline,
                color: AppColors.logoAndTitleTextIconColor(
                    Theme.of(context).brightness),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
