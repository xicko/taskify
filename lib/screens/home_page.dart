import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controllers/list_selection_controller.dart';
import 'package:taskify/theme/colors.dart';
import 'package:taskify/widgets/mylist/home_buttons.dart';
import 'package:taskify/widgets/logo_and_title.dart';
import 'package:taskify/widgets/mylist/my_lists.dart';
import 'package:taskify/widgets/mylist/searchbar_mylist.dart';
import 'package:taskify/widgets/selection_bar.dart';

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
      resizeToAvoidBottomInset: true,
      body: Obx(
        () => AnimatedContainer(
          color: ListSelectionController.to.isSelectionMode.value
              ? AppColors.scaffoldEditMode(Theme.of(context).brightness)
              : Theme.of(context).scaffoldBackgroundColor,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOutQuad,
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final screenHeight = constraints.maxHeight;
                  final keyboardHeight =
                      MediaQuery.of(context).viewInsets.bottom;
                  final availableHeight = screenHeight - keyboardHeight;

                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 30, left: 30, right: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Logo and title
                          LogoAndTitle(),

                          SizedBox(height: 12),

                          SearchBarMyList(),

                          MyLists(availableHeight: availableHeight)
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Buttons
              Positioned(
                bottom: 18,
                left: 0,
                right: 0,
                child: HomeButtons(),
              ),

              // List Bulk Selection Modal
              Obx(
                () => AnimatedPositioned(
                  left: 0,
                  right: 0,
                  top: ListSelectionController.to.isSelectionMode.value
                      ? 0
                      : -100,
                  bottom: 0,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeOutQuad,
                  child: SelectionBar(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
