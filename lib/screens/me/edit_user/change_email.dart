import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controllers/edit_user_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/theme/colors.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  void _onEmailChange() {
    if (EditUserController.to.isEmailChanged.value) {
      final newEmail = EditUserController.to.emailController.text;
      if (newEmail.isNotEmpty) {
        EditUserController.to.updateEmail(newEmail);
      }
    } else {
      UIController.to.getSnackbar('New email cannot be same as old email', '',
          hideMessage: true);
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
              'Change Email',
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
                TextField(
                  cursorColor: AppColors.textFieldCursorColor(
                      Theme.of(context).brightness),
                  controller: EditUserController.to.emailController,
                  style: TextStyle(
                    color: AppColors.bw100(Theme.of(context).brightness),
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

          // Email changed text feedback
          Visibility(
            visible: EditUserController.to.emailUpdateSent.value,
            child: Text(
              'Email change confirmation sent, please check your inbox',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 21, 77, 25),
              ),
            ),
          ),
          SizedBox(
            height: EditUserController.to.emailUpdateSent.value ? 10 : 5,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () => _onEmailChange(),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 36,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shadowColor: Color.fromARGB(110, 255, 255, 255),
                foregroundColor: Colors.black,
                backgroundColor: EditUserController.to.isEmailChanged.value
                    ? Color.fromARGB(255, 131, 206, 255)
                    : Colors.grey[200],
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
        ],
      ),
    );
  }
}
