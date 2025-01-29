import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/controllers/avatar_controller.dart';
import 'package:taskify/controllers/edit_user_controller.dart';
import 'package:taskify/theme/colors.dart';
import 'package:taskify/widgets/dialogs/profile_picture_edit_dialog.dart';
import 'package:taskify/widgets/snackbar.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  // FocusNodes for password change inputs
  final FocusNode _currentPasswordFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

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
          onPressed: () {
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
          },
        ),
      ),
      backgroundColor: AppColors.listDetailBG(Theme.of(context).brightness),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            children: [
              Text(
                'Account settings',
                style: TextStyle(
                  fontSize: 22,
                  color: AppColors.bw100(Theme.of(context).brightness),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 32),

                      Row(
                        spacing: 16,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Obx(
                              () => AvatarController
                                      .to.currentBase64.value.isNotEmpty
                                  ? Image.memory(
                                      AvatarController.to.currentPic(),
                                      height: 160,
                                      width: 160,
                                    )
                                  : Image(
                                      image: AssetImage('assets/avatar.png'),
                                      height: 160,
                                      width: 160,
                                    ),
                            ),
                          ),
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black12,
                              minimumSize: Size(60, 60),
                              maximumSize: Size(60, 60),
                              iconSize: 30,
                            ),
                            onPressed: () => showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => ProfilePictureEditDialog(),
                            ),
                            icon: Icon(
                              Icons.add_photo_alternate_outlined,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 32),

                      // Change Email UI
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Change Email',
                          style: TextStyle(
                            fontSize: 15,
                            color:
                                AppColors.bw100(Theme.of(context).brightness),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Form(
                        child: Column(
                          children: [
                            TextField(
                              cursorColor: AppColors.textFieldCursorColor(
                                  Theme.of(context).brightness),
                              controller: EditUserController.to.emailController,
                              style: TextStyle(
                                color: AppColors.bw100(
                                    Theme.of(context).brightness),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  color: AppColors.textFieldHintTextColor(
                                      Theme.of(context).brightness),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: AppColors.textFieldBorderColor(
                                        Theme.of(context).brightness),
                                  ),
                                ),
                                disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.black54,
                                  ),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: AppColors.textFieldBorderColor(
                                        Theme.of(context).brightness),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color:
                                        AppColors.textFieldFocusedBorderColor(
                                            Theme.of(context).brightness),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),

                      // Email changed text feedback
                      Obx(
                        () => Visibility(
                          visible: EditUserController.to.emailUpdateSent.value,
                          child: Text(
                            'Email change confirmation sent, please check your inbox',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 21, 77, 25)),
                          ),
                        ),
                      ),
                      Obx(
                        () => SizedBox(
                          height: EditUserController.to.emailUpdateSent.value
                              ? 10
                              : 5,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            final newEmail =
                                EditUserController.to.emailController.text;
                            if (newEmail.isNotEmpty) {
                              EditUserController.to
                                  .updateEmail(context, newEmail);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 36,
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shadowColor: Color.fromARGB(110, 255, 255, 255),
                            foregroundColor: Colors.black,
                            backgroundColor: Color.fromARGB(255, 131, 206, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              ),
                            ),
                          ),
                          child: Text(
                            'Change',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),

                      // Update Password UI
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Update Password',
                          style: TextStyle(
                            fontSize: 15,
                            color:
                                AppColors.bw100(Theme.of(context).brightness),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Form(
                        child: Column(
                          children: [
                            TextFormField(
                              obscureText: true,
                              focusNode: _currentPasswordFocusNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode);
                              },
                              cursorColor: AppColors.textFieldCursorColor(
                                  Theme.of(context).brightness),
                              controller: EditUserController
                                  .to.currentPasswordController,
                              style: TextStyle(
                                color: AppColors.bw100(
                                    Theme.of(context).brightness),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Current password',
                                hintStyle: TextStyle(
                                  color: AppColors.textFieldHintTextColor(
                                      Theme.of(context).brightness),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: AppColors.textFieldBorderColor(
                                        Theme.of(context).brightness),
                                  ),
                                ),
                                disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.black54,
                                  ),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: AppColors.textFieldBorderColor(
                                        Theme.of(context).brightness),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color:
                                        AppColors.textFieldFocusedBorderColor(
                                            Theme.of(context).brightness),
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              obscureText: true,
                              focusNode: _passwordFocusNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_confirmPasswordFocusNode);
                              },
                              cursorColor: AppColors.textFieldCursorColor(
                                  Theme.of(context).brightness),
                              controller:
                                  EditUserController.to.newPasswordController,
                              style: TextStyle(
                                color: AppColors.bw100(
                                    Theme.of(context).brightness),
                              ),
                              decoration: InputDecoration(
                                hintText: 'New password',
                                hintStyle: TextStyle(
                                  color: AppColors.textFieldHintTextColor(
                                      Theme.of(context).brightness),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: AppColors.textFieldBorderColor(
                                        Theme.of(context).brightness),
                                  ),
                                ),
                                disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.black54,
                                  ),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: AppColors.textFieldBorderColor(
                                        Theme.of(context).brightness),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color:
                                        AppColors.textFieldFocusedBorderColor(
                                            Theme.of(context).brightness),
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              obscureText: true,
                              focusNode: _confirmPasswordFocusNode,
                              textInputAction: TextInputAction.done,
                              cursorColor: AppColors.textFieldCursorColor(
                                  Theme.of(context).brightness),
                              controller: EditUserController
                                  .to.confirmNewPasswordController,
                              style: TextStyle(
                                color: AppColors.bw100(
                                    Theme.of(context).brightness),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Confirm new password',
                                hintStyle: TextStyle(
                                  color: AppColors.textFieldHintTextColor(
                                      Theme.of(context).brightness),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: AppColors.textFieldBorderColor(
                                        Theme.of(context).brightness),
                                  ),
                                ),
                                disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.black54,
                                  ),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: AppColors.textFieldBorderColor(
                                        Theme.of(context).brightness),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color:
                                        AppColors.textFieldFocusedBorderColor(
                                            Theme.of(context).brightness),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),

                      // Password updated text feedback
                      Obx(
                        () => Visibility(
                            visible:
                                EditUserController.to.passwordUpdatedText.value,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Password updated.',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 21, 77, 25)),
                              ),
                            )),
                      ),
                      Obx(
                        () => SizedBox(
                          height:
                              EditUserController.to.passwordUpdatedText.value
                                  ? 10
                                  : 5,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            final currentPassword = EditUserController
                                .to.currentPasswordController.text;
                            final newPassword = EditUserController
                                .to.newPasswordController.text;
                            final confirmPassword = EditUserController
                                .to.confirmNewPasswordController.text;

                            // Asks to fill all fields if any of the input is empty
                            // Then compares if current password and new password are different
                            // Then if different, makes sure new password and confirm new password
                            // fields match, and if they match it then lets the user update password
                            if (currentPassword.isEmpty ||
                                newPassword.isEmpty ||
                                confirmPassword.isEmpty) {
                              CustomSnackBar(context)
                                  .show('Please fill all fields');
                            } else {
                              // Comparing current and new passwords
                              if (currentPassword != newPassword) {
                                // Making sure both new password fields match
                                if (newPassword == confirmPassword) {
                                  // Update password
                                  EditUserController.to
                                      .updatePassword(context, newPassword);
                                  CustomSnackBar(context)
                                      .show('Password updated!');
                                } else {
                                  CustomSnackBar(context)
                                      .show('Passwords do not match');
                                }
                              } else {
                                CustomSnackBar(context).show(
                                    'New password cannot be same as current password');
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 36,
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shadowColor: Color.fromARGB(110, 255, 255, 255),
                            foregroundColor: Colors.black,
                            backgroundColor: Color.fromARGB(255, 131, 206, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              ),
                            ),
                          ),
                          child: Text(
                            'Update',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
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
