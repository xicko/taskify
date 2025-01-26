import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/controllers/base_controller.dart';
import 'package:taskify/controllers/list_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/theme/colors.dart';
import 'package:taskify/widgets/snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // Text Controllers for login inputs
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // FocusNodes for login inputs
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // For Login Button
  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      AuthService()
          .signInWithEmailPassword(context, email, password)
          .then((response) async {
        if (response.session != null) {
          if (mounted) {
            CustomSnackBar(context).show("Login successful!");
          }

          // hiding login modal if login successful(state)
          UIController.to.loginVisibility.value = false;

          // Refresh lists
          ListController.to.pagingController.refresh();
          ListController.to.publicPagingController.refresh();
        } else {
          if (mounted) {
            CustomSnackBar(context).show("Login failed. Check credentials.");
          }
        }
      }).catchError(
        (e) {
          // CustomSnackBar(context).show("Error: $e");
          UIController.to.getSnackbar(
            'Error: $e',
            '',
            shadows: false,
          );
        },
      );
    } else {
      CustomSnackBar(context).show('Please fill in all fields.');
    }

    ListController.to.pagingController.refresh();
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
                  borderRadius: BorderRadius.circular(8),
                ),
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
                              'Log in',
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
                              textInputAction: TextInputAction.next,
                              controller: _emailController,
                              focusNode: _emailFocusNode,
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
                              textInputAction: TextInputAction.done,
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
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
                                    width: 2,
                                  ),
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
                                  'Don\'t have an account?',
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
                                    BaseController.to.switchAuthScreen(1);
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
                                    'Sign up here',
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
                              // Login
                              onPressed: () => _login(),
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
                                'Log in',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
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
        )
      ],
    );
  }
}
