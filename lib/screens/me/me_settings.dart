import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/controllers/auth_controller.dart';
import 'package:taskify/controllers/avatar_controller.dart';
import 'package:taskify/controllers/edit_user_controller.dart';
import 'package:taskify/controllers/lists_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/widgets/abouttaskify.dart';
import 'package:taskify/screens/me/edit_user.dart';
import 'package:taskify/theme/colors.dart';
import 'package:taskify/widgets/dialogs/delete_all_list_dialog.dart';
import 'package:taskify/widgets/dialogs/profile_picture_edit_dialog.dart';

class MeSettings extends StatefulWidget {
  const MeSettings({super.key});

  @override
  MeSettingsState createState() => MeSettingsState();
}

class MeSettingsState extends State<MeSettings> {
  void _onLogout() async {
    UIController.to.getSnackbar('Logging out', '', hideMessage: true);

    // Delayed Log out
    await Future.delayed(Duration(milliseconds: 1000));
    if (context.mounted) {
      AuthController.to.signOut();
    }

    // Refresh users list after slight delay
    await Future.delayed(Duration(milliseconds: 100));
    ListsController.to.pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    // getting user's device screen height/width
    double screenHeight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;

    // checking if dark mode is on for theming some widgets
    final isDarkMode = // ignore: unused_local_variable
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenwidth * 0.2),
          child: Column(
            spacing: 15,
            children: [
              SizedBox(height: screenHeight * 0.04),
              InkWell(
                onTap: () => showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => ProfilePictureEditDialog(),
                ),
                child: ClipOval(
                  child: Obx(
                    () => AvatarController.to.currentBase64.value.isNotEmpty
                        ? Image.memory(
                            AvatarController.to.currentPic(),
                            height: 100,
                            width: 100,
                          )
                        : Image(
                            image: AssetImage('assets/avatar.png'),
                            height: 100,
                            width: 100,
                          ),
                  ),
                ),
              ),
              Text(
                AuthService().getCurrentUserEmail() ?? 'No email available',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.bw100(Theme.of(context).brightness),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  elevation: WidgetStateProperty.all(0),
                  backgroundColor: WidgetStateProperty.all(
                    Color.fromARGB(255, 196, 231, 255),
                  ),
                  foregroundColor: WidgetStateProperty.all(Colors.black),
                  overlayColor: WidgetStateProperty.all(
                    Color.fromARGB(255, 165, 205, 232),
                  ),
                ),
                onPressed: () {
                  EditUserController.to.fillUserEmail();

                  // Open page
                  UIController.to.openScreen(
                    context,
                    EditUser(),
                    direction: OpenScreenType.fromBottom,
                  );
                },
                child: Text('Account Settings'),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () async {
                var userId = AuthService().getCurrentUserId();

                if (userId != null) {
                  await ListsController.to.exportUserLists(0);
                } else {
                  // Handle the case where no user is logged in
                  // CustomSnackBar(context).show('No user is logged in. Please log in to export lists.');
                  UIController.to.getSnackbar(
                    'No user is logged in.',
                    'Please log in to export lists.',
                    shadows: false,
                  );
                }
              },
              style: TextButton.styleFrom(
                  foregroundColor:
                      AppColors.bw100(Theme.of(context).brightness),
                  overlayColor: Color.fromARGB(255, 98, 98, 98),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                  ),
                  minimumSize: Size(double.infinity, 48),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Export all lists (.json)'),
                ),
              ),
            ),

            // Delete all lists button with confirmation dialog
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DeleteAllListDialog();
                  },
                );
              },
              style: TextButton.styleFrom(
                  foregroundColor:
                      AppColors.bw100(Theme.of(context).brightness),
                  overlayColor: Color.fromARGB(255, 98, 98, 98),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                  ),
                  minimumSize: Size(double.infinity, 48),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Delete all lists'),
                ),
              ),
            ),

            // About us button
            TextButton(
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
              style: TextButton.styleFrom(
                  foregroundColor:
                      AppColors.bw100(Theme.of(context).brightness),
                  overlayColor: Color.fromARGB(255, 98, 98, 98),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                  ),
                  minimumSize: Size(double.infinity, 48),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('About Taskify'),
                ),
              ),
            ),

            // Log out button
            TextButton(
              onPressed: () => _onLogout(),
              style: TextButton.styleFrom(
                  foregroundColor:
                      AppColors.bw100(Theme.of(context).brightness),
                  overlayColor: Color.fromARGB(255, 98, 98, 98),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                  ),
                  minimumSize: Size(double.infinity, 48),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Log out',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
