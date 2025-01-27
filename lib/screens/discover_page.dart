import 'package:flutter/material.dart';
import 'package:taskify/controllers/lists_controller.dart';
import 'package:taskify/widgets/discoverlist/discover_buttons.dart';
import 'package:taskify/widgets/logo_and_title.dart';
import 'package:taskify/widgets/discoverlist/discover_lists.dart';
// import 'package:todo/theme/colors.dart'; // theme specific colors

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  DiscoverPageState createState() => DiscoverPageState();
}

class DiscoverPageState extends State<DiscoverPage>
    with AutomaticKeepAliveClientMixin {
  @override
  // called at app startup
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    // Refreshing lists at start
    ListsController.to.publicPagingController.refresh();
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

    super.build(context);
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

                  // Public Lists
                  DiscoverLists(),
                ],
              ),
            ),
          ),

          // Buttons
          Positioned(
            bottom: 18,
            left: 0,
            right: 0,
            child: DiscoverButtons(),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
