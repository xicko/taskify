import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controllers/auth_controller.dart';
import 'package:taskify/controllers/base_controller.dart';
import 'package:taskify/screens/me/login_page.dart';
import 'package:taskify/screens/me/me_settings.dart';
import 'package:taskify/screens/me/signup_page.dart';
import 'package:taskify/theme/colors.dart';
// import 'package:todo/theme/colors.dart'; // theme specific colors

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  MePageState createState() => MePageState();
}

class MePageState extends State<MePage> with AutomaticKeepAliveClientMixin {
  // main widgets part
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
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            color: AppColors.listDetailBG(Theme.of(context).brightness),
            child: Center(
              child: Obx(
                () => Column(
                  mainAxisAlignment: AuthController.to.isLoggedIn.value
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: <Widget>[
                    // SizedBox(height: screenHeight * 0.1),

                    // Show settings if logged in, otherwise show login dialog
                    AuthController.to.isLoggedIn.value
                        ? MeSettings()
                        : Obx(
                            () => IndexedStack(
                              index: BaseController.to.authScreen.value,
                              children: [
                                LoginPage(),
                                SignupPage(),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
