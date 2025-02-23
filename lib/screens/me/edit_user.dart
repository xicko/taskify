import 'package:flutter/material.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/controllers/edit_user_controller.dart';
import 'package:taskify/screens/me/edit_user/change_email.dart';
import 'package:taskify/screens/me/edit_user/profile_picture.dart';
import 'package:taskify/screens/me/edit_user/update_password.dart';
import 'package:taskify/theme/colors.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  void _onPageClose() {
    // Default back function
    Navigator.of(context).pop();

    // Clearing password controllers if closed
    EditUserController.to.currentPasswordController.clear();
    EditUserController.to.newPasswordController.clear();
    EditUserController.to.confirmNewPasswordController.clear();

    // Disabling feedback text if closed
    EditUserController.to.emailUpdateSent.value = false;
    EditUserController.to.passwordUpdatedText.value = false;

    // Refreshing Supabase session if closed
    AuthService().supabase.auth.refreshSession();
  }

  @override
  void initState() {
    super.initState();
    EditUserController.to.fillUserEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.listDetailBG(Theme.of(context).brightness),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.bw100(Theme.of(context).brightness),
          ),
          onPressed: () => _onPageClose(),
        ),
        title: Text(
          'Account settings',
          style: TextStyle(
            fontSize: 22,
            color: AppColors.bw100(Theme.of(context).brightness),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: AppColors.listDetailBG(Theme.of(context).brightness),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 24),

                      ProfilePicture(),

                      SizedBox(height: 32),

                      // Change Email UI
                      ChangeEmail(),

                      SizedBox(height: 40),

                      // Update Password UI
                      UpdatePassword(),

                      SizedBox(height: 400),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
