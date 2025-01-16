// import 'package:entryflow/theme/colors.dart'; // theme specific colors
import 'package:flutter/material.dart';
import 'package:taskify/widgets/mylist/home_buttons.dart';
import 'package:taskify/widgets/logo_and_title.dart';
import 'package:taskify/widgets/mylist/my_lists.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // runs at app start
  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    // Refreshing lists at start
    // ListController.to.pagingController.refresh();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Main UI
  @override
  Widget build(BuildContext context) {
    // Getting user's device screen height/width
    double screenHeight = // ignore: unused_local_variable
        MediaQuery.of(context).size.height;
    double screenwidth = // ignore: unused_local_variable
        MediaQuery.of(context).size.width;

    // Checking if dark mode is on for theming some widgets
    final isDarkMode = // ignore: unused_local_variable
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo and title
                  LogoAndTitle(),

                  SizedBox(height: 12),

                  // Your Lists
                  MyLists(),
                ],
              ),
            ),
          ),

          // Buttons
          Positioned(
            bottom: 18,
            left: 0,
            right: 0,
            child: HomeButtons(),
          ),
        ],
      ),
    );
  }
}
