import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controllers/edit_user_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/theme/colors.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  void _onPasswordUpdate() {
    if (EditUserController.to.isPasswordValid.value) {
      if (EditUserController.to.currentPasswordController.text.length > 7) {
        if (EditUserController.to.newPasswordController.text ==
            EditUserController.to.confirmNewPasswordController.text) {
          if (EditUserController.to.newPasswordController.text.length > 7 &&
              EditUserController.to.confirmNewPasswordController.text.length >
                  7) {
            EditUserController.to.updatePassword(
                context, EditUserController.to.newPasswordController.text);
          } else {
            UIController.to.getSnackbar(
                'Password must be minimum 8 characters', '',
                hideMessage: true);
          }
        } else {
          UIController.to
              .getSnackbar('Passwords do not match', '', hideMessage: true);
        }
      } else {
        UIController.to
            .getSnackbar('Current password is invalid', '', hideMessage: true);
      }
    } else {
      UIController.to.getSnackbar('Password is invalid', 'Please try again',
          hideMessage: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Update Password',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.bw100(Theme.of(context).brightness),
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
                  focusNode: EditUserController.to.currentPasswordFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context)
                        .requestFocus(EditUserController.to.passwordFocusNode);
                  },
                  cursorColor: AppColors.textFieldCursorColor(
                      Theme.of(context).brightness),
                  controller: EditUserController.to.currentPasswordController,
                  style: TextStyle(
                    color: AppColors.bw100(Theme.of(context).brightness),
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
                        color: AppColors.textFieldFocusedBorderColor(
                            Theme.of(context).brightness),
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  obscureText: true,
                  focusNode: EditUserController.to.passwordFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(
                        EditUserController.to.confirmPasswordFocusNode);
                  },
                  cursorColor: AppColors.textFieldCursorColor(
                      Theme.of(context).brightness),
                  controller: EditUserController.to.newPasswordController,
                  style: TextStyle(
                    color: AppColors.bw100(Theme.of(context).brightness),
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
                        color: AppColors.textFieldFocusedBorderColor(
                            Theme.of(context).brightness),
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  obscureText: true,
                  focusNode: EditUserController.to.confirmPasswordFocusNode,
                  textInputAction: TextInputAction.done,
                  cursorColor: AppColors.textFieldCursorColor(
                      Theme.of(context).brightness),
                  controller:
                      EditUserController.to.confirmNewPasswordController,
                  style: TextStyle(
                    color: AppColors.bw100(Theme.of(context).brightness),
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
                        color: AppColors.textFieldFocusedBorderColor(
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
          Visibility(
            visible: EditUserController.to.passwordUpdatedText.value,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Password updated.',
                style: TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 21, 77, 25)),
              ),
            ),
          ),
          SizedBox(
            height: EditUserController.to.passwordUpdatedText.value ? 10 : 5,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () => _onPasswordUpdate(),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 36,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shadowColor: Color.fromARGB(110, 255, 255, 255),
                foregroundColor: Colors.black,
                backgroundColor: EditUserController.to.isPasswordValid.value
                    ? Color.fromARGB(255, 131, 206, 255)
                    : Colors.grey[200],
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
        ],
      ),
    );
  }
}
