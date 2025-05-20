import 'dart:convert';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controllers/list_creation_controller.dart';
import 'package:taskify/theme/colors.dart';
import 'package:taskify/theme/theme.dart';
import 'package:taskify/widgets/new_list/cancel_button.dart';
import 'package:taskify/widgets/new_list/create_save_button.dart';
import 'package:taskify/widgets/new_list/privacy_toggle.dart';

class NewList extends StatefulWidget {
  const NewList({super.key});

  @override
  NewListState createState() => NewListState();
}

class NewListState extends State<NewList> {
  // TextField Controllers
  final TextEditingController titleController =
      ListCreationController.to.titleController;
  final FleatherController contentController =
      ListCreationController.to.fleatherContentController;

  // FocusNodes for textfields
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

  // Flag to track characterCount in content
  final ValueNotifier<int> characterCount = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    contentController.addListener(() {
      characterCount.value =
          contentController.plainTextEditingValue.text.length - 1;
    });

    if (ListCreationController.to.editListId?.value != null) {
      // Checks if editListId is not null. If true, it populates the fields
      // Basically populating fields if editing
      titleController.text = ListCreationController.to.editTitle?.value ?? '';
      // contentController.plainTextEditingValue.text = ListCreationController.to.editContent?.value ?? '';
      ListCreationController.to.isPublic.value =
          ListCreationController.to.editIsPublic?.value ?? false;
    } else {
      // Clear
      titleController.clear();
      contentController.clear();
      ListCreationController.to.isPublic.value = false;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();

    characterCount.dispose();

    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Getting user's device screen height/width
    double screenHeight = MediaQuery.of(context).size.height;
    double screenwidth // ignore: unused_local_variable
        = MediaQuery.of(context).size.width;

    // Checking if dark mode is on for theming some widgets
    final isDarkMode = // ignore: unused_local_variable
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: screenHeight * 0.3, maxHeight: screenHeight * 0.3),
              child: Container(
                color: AppColors.scaffold(Theme.of(context).brightness),
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final screenHeight = constraints.maxHeight;
              final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
              final availableHeight = screenHeight - keyboardHeight;

              // Only populate inputs if EditMode is true, and both controllers are empty
              if (ListCreationController.to.isEditMode.value &&
                  titleController.text.isEmpty) {
                if (titleController.text.isEmpty) {
                  titleController.text =
                      ListCreationController.to.editTitle?.value ?? '';
                  // Clear existing document content
                  ListCreationController.to.fleatherContentController.document
                      .delete(
                    0,
                    ListCreationController
                        .to.fleatherContentController.document.length,
                  );

                  // Set content
                  try {
                    final rawContent =
                        ListCreationController.to.editContent?.value;
                    Delta delta;

                    if (rawContent == null || rawContent.isEmpty) {
                      delta = Delta(); // Empty document if there's no content
                    } else {
                      // Check if the content is a valid Delta JSON
                      try {
                        final parsedJson = jsonDecode(rawContent);
                        if (parsedJson is List) {
                          delta = Delta.fromJson(parsedJson);
                        } else {
                          throw FormatException("Not a valid Delta JSON");
                        }
                      } catch (e) {
                        // If it's not valid Delta JSON, treat it as plain text and insert
                        delta = Delta()..insert('$rawContent\n');
                      }
                    }

                    // Apply the Delta to the Fleather document
                    ListCreationController.to.fleatherContentController.document
                        .compose(
                      delta,
                      ChangeSource.local,
                    );
                  } catch (e) {
                    debugPrint("Error parsing content: $e");
                  }

                  ListCreationController.to.isPublic.value =
                      ListCreationController.to.editIsPublic?.value ?? false;
                }
              }

              return Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, bottom: 75),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: availableHeight * 0.03), // Top space

                      // Title
                      Text(
                        ListCreationController.to.isEditMode.value
                            ? 'Edit List'
                            : 'Create New List',
                        style: TextStyle(
                          fontSize: 24,
                          color: AppColors.logoAndTitleTextIconColor(
                              Theme.of(context).brightness),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Inputs container
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(39, 0, 0, 0),
                                blurRadius: 3,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Title input
                              Padding(
                                padding: EdgeInsets.fromLTRB(32, 16, 32, 0),
                                child: TextField(
                                  controller: titleController,
                                  maxLines: 1,
                                  maxLength: 70,
                                  cursorColor: Colors.black,
                                  focusNode: _titleFocusNode,
                                  textInputAction: TextInputAction.next,
                                  onSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_contentFocusNode);
                                  },
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    counter: null,
                                    counterText: '',
                                    hintText: 'Title',
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black45,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black38,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // List input
                              Expanded(
                                child: Stack(
                                  children: [
                                    FleatherTheme(
                                      data: lightFleather,
                                      child: FleatherEditor(
                                        focusNode: _contentFocusNode,
                                        autocorrect: false,
                                        expands: true,
                                        scrollable: true,
                                        padding: EdgeInsets.only(
                                            left: 32,
                                            right: 32,
                                            top: 12,
                                            bottom: 24),
                                        controller: ListCreationController
                                            .to.fleatherContentController,
                                      ),
                                    ),

                                    // Hint Text
                                    if (!ListCreationController
                                        .to.isEditMode.value)
                                      Positioned(
                                        top: 12,
                                        left: 32,
                                        child: Obx(
                                          () => Visibility(
                                            visible: ListCreationController
                                                .to.isFleatherEmpty.value,
                                            child: Text(
                                              'To-do list',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black45,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              // Rich Text Formatter Controls
                              SizedBox(
                                height: 36,
                                child: FleatherToolbar.basic(
                                    leading: [
                                      SizedBox(width: 16),
                                    ],
                                    trailing: [
                                      SizedBox(width: 16),
                                    ],
                                    padding: EdgeInsets.all(0),
                                    controller: ListCreationController
                                        .to.fleatherContentController),
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Character Count
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 24, bottom: 4),
                                    child: ValueListenableBuilder<int>(
                                      valueListenable: characterCount,
                                      builder: (context, count, child) {
                                        return Text(
                                          '$count / 5000',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  // Privacy Toggle
                                  PrivacyToggle(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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
            child: Row(
              spacing: 14,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Closing button
                CancelButton(),

                // Create / Save button
                CreateSaveButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
