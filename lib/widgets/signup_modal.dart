// not used

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskify/controllers/base_controller.dart';
import 'package:taskify/widgets/snackbar.dart';

class SignupForm extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(String email, String password) onSignup;
  final VoidCallback promptLogIn;

  const SignupForm({
    super.key,
    required this.onCancel,
    required this.onSignup,
    required this.promptLogIn,
  });

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  // final _formSignupKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(children: [
        Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 300,
              maxWidth: 300,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // inputs
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Sign up',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 22),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        maxLines: 1,
                        maxLength: 40,
                        controller: _emailController,
                        cursorColor: Color.fromARGB(255, 35, 77, 106),
                        decoration: InputDecoration(
                            hintText: 'Email',
                            counterText: '',
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 35, 77, 106),
                                    width: 2))),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9@._+-]')),
                        ],
                      ),
                      SizedBox(height: 4),
                      TextFormField(
                        maxLines: 1,
                        maxLength: 64,
                        controller: _passwordController,
                        obscureText: true,
                        cursorColor: Color.fromARGB(255, 35, 77, 106),
                        decoration: InputDecoration(
                            hintText: 'Password',
                            counterText: '',
                            errorMaxLines: 2,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 35, 77, 106),
                                    width: 2))),
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
                        obscureText: true,
                        cursorColor: Color.fromARGB(255, 35, 77, 106),
                        decoration: InputDecoration(
                            hintText: 'Repeat password',
                            counterText: '',
                            errorMaxLines: 2,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 35, 77, 106),
                                    width: 2))),
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
                          Text('Already have an account?'),
                          TextButton(
                            onPressed: widget.promptLogIn,
                            style: ButtonStyle(
                              foregroundColor:
                                  WidgetStateProperty.all(Colors.black),
                              padding: WidgetStateProperty.all(EdgeInsets.zero),
                              overlayColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: WidgetStateProperty.all(Size.zero),
                            ),
                            child: Text(
                              'Log in here',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),

                SizedBox(height: 0),

                // buttons if navbar index is 0 and 1
                if (BaseController.to.currentNavIndex.value == 0 ||
                    BaseController.to.currentNavIndex.value == 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.onCancel,
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(12),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                              )),
                              elevation: 0,
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black),
                          child: Text('Cancel'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();
                            final confirmPassword =
                                _confirmPasswordController.text.trim();

                            if (email.isEmpty ||
                                password.isEmpty ||
                                confirmPassword.isEmpty) {
                              CustomSnackBar(context)
                                  .show('Please fill all fields.');
                            }

                            // allows signup if both password fields match
                            if (password == confirmPassword) {
                              widget.onSignup(email, password);
                            } else {
                              CustomSnackBar(context).show(
                                  "Passwords do not match. Please try again.");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(12),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(8))),
                              elevation: 0,
                              backgroundColor:
                                  Color.fromARGB(255, 131, 206, 255),
                              foregroundColor: Colors.black),
                          child: Text('Sign up'),
                        ),
                      )
                    ],
                  ),

                // buttons if navbar index is 2
                if (BaseController.to.currentNavIndex.value == 2)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();
                            final confirmPassword =
                                _confirmPasswordController.text.trim();

                            if (email.isEmpty ||
                                password.isEmpty ||
                                confirmPassword.isEmpty) {
                              CustomSnackBar(context)
                                  .show('Please fill all fields.');
                            }

                            // allows signup if both password fields match
                            if (password == confirmPassword) {
                              widget.onSignup(email, password);
                            } else {
                              CustomSnackBar(context).show(
                                  "Passwords do not match. Please try again.");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(12),
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              elevation: 0,
                              backgroundColor:
                                  Color.fromARGB(255, 131, 206, 255),
                              foregroundColor: Colors.black),
                          child: Text('Sign up'),
                        ),
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
