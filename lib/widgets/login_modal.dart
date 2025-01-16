// not used

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskify/widgets/snackbar.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(String email, String password) onLogin;
  final VoidCallback promptSignUp;

  const LoginForm({
    super.key,
    required this.onCancel,
    required this.onLogin,
    required this.promptSignUp,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                        'Log in',
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
                      SizedBox(height: 20),
                      Column(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account?'),
                          TextButton(
                            onPressed: widget.promptSignUp,
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
                              'Sign up here',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          )
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

                          if (email.isNotEmpty && password.isNotEmpty) {
                            widget.onLogin(email, password);
                          } else {
                            CustomSnackBar(context)
                                .show('Please fill in all fields.');
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
                            backgroundColor: Color.fromARGB(255, 131, 206, 255),
                            foregroundColor: Colors.black),
                        child: Text('Log in'),
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
