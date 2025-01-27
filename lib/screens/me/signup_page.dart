import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/controllers/base_controller.dart';
import 'package:taskify/controllers/lists_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/theme/colors.dart';
import 'package:taskify/widgets/snackbar.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  // Text Controllers for signup inputs
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // FocusNodes for signup inputs
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  // For Sign Up Button
  void _signup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      CustomSnackBar(context).show('Please fill all fields.');
    }

    // allows signup if both password fields match
    if (password == confirmPassword) {
      AuthService().signUpWithEmailPassword(context, email, password).then(
        (response) {
          if (response?.session != null) {
            if (mounted) {
              CustomSnackBar(context).show("Sign up successful!");
            }

            // hiding signup modal if signup successful(state)
            UIController.to.signupVisibility.value = false;
          } else {
            if (mounted) {
              CustomSnackBar(context).show(
                "Sign up failed. Check credentials.",
              );
            }
          }
        },
      ).catchError(
        (e) {
          if (mounted) {
            CustomSnackBar(context).show("Error: $e");
          }
        },
      );
    } else {
      CustomSnackBar(context).show("Passwords do not match. Please try again.");
    }

    await Future.delayed(Duration(milliseconds: 100));
    ListsController.to.pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    // getting user's device screen height/width
    double screenHeight = // ignore: unused_local_variable
        MediaQuery.of(context).size.height;
    double screenwidth = // ignore: unused_local_variable
        MediaQuery.of(context).size.width;

    // checking if dark mode is on for theming some widgets
    final isDarkMode = // ignore: unused_local_variable
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Wrap(
            children: [
              Material(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // inputs
                      Padding(
                        padding: EdgeInsets.only(bottom: 24),
                        child: Column(
                          children: [
                            Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                color: AppColors.bw100(
                                    Theme.of(context).brightness),
                              ),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              maxLines: 1,
                              maxLength: 40,
                              controller: _emailController,
                              focusNode: _emailFocusNode,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode);
                              },
                              cursorColor: AppColors.textFieldCursorColor(
                                  Theme.of(context).brightness),
                              style: TextStyle(
                                color: AppColors.bw100(
                                    Theme.of(context).brightness),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Email',
                                counterText: '',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.textFieldBorderColor(
                                        Theme.of(context).brightness),
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          AppColors.textFieldFocusedBorderColor(
                                              Theme.of(context).brightness),
                                      width: 2),
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9@._+-]'),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            TextFormField(
                              maxLines: 1,
                              maxLength: 64,
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_confirmPasswordFocusNode);
                              },
                              obscureText: true,
                              cursorColor: AppColors.textFieldCursorColor(
                                  Theme.of(context).brightness),
                              style: TextStyle(
                                color: AppColors.bw100(
                                    Theme.of(context).brightness),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Password',
                                counterText: '',
                                errorMaxLines: 2,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.textFieldBorderColor(
                                        Theme.of(context).brightness),
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          AppColors.textFieldFocusedBorderColor(
                                              Theme.of(context).brightness),
                                      width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 4),
                            TextFormField(
                              maxLines: 1,
                              maxLength: 64,
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocusNode,
                              textInputAction: TextInputAction.done,
                              obscureText: true,
                              cursorColor: AppColors.textFieldCursorColor(
                                  Theme.of(context).brightness),
                              style: TextStyle(
                                color: AppColors.bw100(
                                    Theme.of(context).brightness),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Repeat password',
                                counterText: '',
                                errorMaxLines: 2,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.textFieldBorderColor(
                                        Theme.of(context).brightness),
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          AppColors.textFieldFocusedBorderColor(
                                              Theme.of(context).brightness),
                                      width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Column(
                              spacing: 8,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: TextStyle(
                                    color: AppColors.bw100(
                                        Theme.of(context).brightness),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Unfocusing elements, mostly for text fields
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();

                                    // Switching auth screen
                                    BaseController.to.switchAuthScreen(0);
                                  },
                                  style: ButtonStyle(
                                    foregroundColor:
                                        WidgetStateProperty.all(Colors.black),
                                    padding: WidgetStateProperty.all(
                                        EdgeInsets.zero),
                                    overlayColor: WidgetStateProperty.all(
                                        Colors.transparent),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    minimumSize:
                                        WidgetStateProperty.all(Size.zero),
                                  ),
                                  child: Text(
                                    'Log in here',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.bw100(
                                          Theme.of(context).brightness),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              // Sign up
                              onPressed: () => _signup(),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(12),
                                minimumSize: Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                elevation: 20,
                                shadowColor: AppColors.authButtonShadow(
                                    Theme.of(context).brightness),
                                backgroundColor:
                                    Color.fromARGB(255, 131, 206, 255),
                                foregroundColor: Colors.black,
                              ),
                              child: Text(
                                'Create an account',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
