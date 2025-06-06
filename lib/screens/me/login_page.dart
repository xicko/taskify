import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/controllers/auth_controller.dart';
import 'package:taskify/controllers/base_controller.dart';
import 'package:taskify/controllers/lists_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/theme/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // Text Controllers for login inputs
  final TextEditingController _emailController = AuthController.to.loginEmailController;
  final TextEditingController _passwordController = AuthController.to.loginPasswordController;

  // FocusNodes for login inputs
  final FocusNode _emailFocusNode = AuthController.to.loginEmailFocusNode;
  final FocusNode _passwordFocusNode = AuthController.to.loginPasswordFocusNode;

  @override
  void initState() {
    super.initState();
  }

  // For Login Button
  void _login() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      AuthService()
          .signInWithEmailPassword(email, password)
          .then((response) async {
        if (response.session != null) {
          UIController.to
              .getSnackbar('Login successful!', '', hideMessage: true);

          localStorage.setString('rememberEmail', email);

          // hiding login modal if login successful(state)
          UIController.to.loginVisibility.value = false;

          // Refresh lists
          ListsController.to.pagingController.refresh();
          ListsController.to.publicPagingController.refresh();
        } else {
          UIController.to.getSnackbar('Login failed.', 'Check credentials.');
        }
      }).catchError(
        (e) {
          UIController.to.getSnackbar(
            'Error: $e',
            '',
            shadows: false,
          );
        },
      );
    } else {
      UIController.to
          .getSnackbar('Please fill in all fields.', '', hideMessage: true);
    }

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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),

                      // inputs
                      Padding(
                        padding: EdgeInsets.only(bottom: 24),
                        child: Obx(
                          () => Column(
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
                                // onChanged: (value) => AuthController.to.onLoginInputChange(value),
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
                                onFieldSubmitted: (_) {
                                  if (_emailController.text.isNotEmpty ||
                                      _passwordController.text.isNotEmpty) {
                                    _login();
                                  }
                                },
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
                              SizedBox(height: 6),

                              // remember me checkbox
                              Row(
                                children: [
                                  Checkbox(
                                      value: AuthController.to.rememberEmailChecked.value,
                                      onChanged: (bool? value) => AuthController.to.handleRememberEmail(value),
                                  ),
                                  Text('Remember email'),
                                ],
                              ),
                              SizedBox(height: 6),

                              // misc
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
