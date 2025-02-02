import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/constants/forbidden_words.dart';
import 'package:taskify/controllers/lists_controller.dart';
import 'package:taskify/controllers/list_creation_controller.dart';
import 'package:taskify/theme/colors.dart';
import 'package:taskify/widgets/snackbar.dart';

class NewListModal extends StatefulWidget {
  const NewListModal({
    super.key,
  });

  @override
  NewListModalState createState() => NewListModalState();
}

class NewListModalState extends State<NewListModal> {
  // TextField Controllers
  final TextEditingController titleController =
      ListCreationController.to.titleController;
  final TextEditingController contentController =
      ListCreationController.to.contentController;

  // FocusNodes for textfields
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

  // Flag to track characterCount in content
  final ValueNotifier<int> characterCount = ValueNotifier<int>(0);

  // Create / edit list
  void _createOrSave() async {
    String title = titleController.text;
    String content = contentController.text;

    // Forbidden words detector
    bool containsForbiddenWords(String text) {
      for (String word in forbiddenWords) {
        if (text.toLowerCase().contains(word.toLowerCase())) {
          return true;
        }
      }
      return false;
    }

    if (title.isEmpty || content.isEmpty) {
      CustomSnackBar(context).show('List cannot be empty');
    } else if (ListCreationController.to.isPublic.value &&
        // If ispublic toggle is true, check for forbidden words
        (containsForbiddenWords(title) || containsForbiddenWords(content))) {
      CustomSnackBar(context)
          .show('Inappropriate language is not allowed in public lists.');
    } else {
      if (ListCreationController.to.isEditMode.value == false) {
        // Creation
        ListCreationController.to.createList(
            context, title, content, ListCreationController.to.isPublic.value);
      } else {
        // Editing
        ListCreationController.to.updateList(
          context,
          title,
          content,
          ListCreationController.to.isPublic.value,
          ListCreationController.to.editListId!.value!,
        );
      }

      // Refreshing lists after
      await Future.delayed(Duration(milliseconds: 800));
      ListsController.to.pagingController.refresh();
      ListsController.to.publicPagingController.refresh();

      // Resetting the new list modal after creation
      await Future.delayed(Duration(milliseconds: 1000));
      titleController.clear();
      contentController.clear();
      ListCreationController.to.isPublic.value = false;
    }
  }

  void _cancel() {
    // Closing NewListModal
    ListCreationController.to.isNewListModalVisible.value = false;

    // Unfocusing text fields
    _titleFocusNode.unfocus();
    _contentFocusNode.unfocus();

    // Clearing isPublic toggle on cancel if EditMode was true
    // Basically clearing the toggle for the next time the modal is opened
    if (ListCreationController.to.isEditMode.value) {
      ListCreationController.to.isPublic.value = false;
    }
  }

  @override
  void initState() {
    super.initState();

    contentController.addListener(() {
      characterCount.value = contentController.text.length;
    });

    if (ListCreationController.to.editListId?.value != null) {
      // Checks if editListId is not null. If true, it populates the fields
      // Basically populating fields if editing
      titleController.text = ListCreationController.to.editTitle?.value ?? '';
      contentController.text =
          ListCreationController.to.editContent?.value ?? '';
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
                  titleController.text.isEmpty &&
                  contentController.text.isEmpty) {
                titleController.text =
                    ListCreationController.to.editTitle?.value ?? '';
                contentController.text =
                    ListCreationController.to.editContent?.value ?? '';
                ListCreationController.to.isPublic.value =
                    ListCreationController.to.editIsPublic?.value ?? false;
              }

              return Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, bottom: 75),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: availableHeight * 0.06), // Top space

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
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 32, right: 32, top: 4, bottom: 24),
                                  child: TextField(
                                    controller: contentController,
                                    focusNode: _contentFocusNode,
                                    maxLength: 5000,
                                    maxLines: null,
                                    cursorColor: Colors.black,
                                    textInputAction: TextInputAction.newline,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 0,
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 0,
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 0,
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 0,
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      counter: null,
                                      counterText: '',
                                      hintText: 'To-do list',
                                      hintStyle: TextStyle(
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ),
                                ),
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

                                  // Audience Toggle
                                  Expanded(
                                    child: Obx(
                                      () => SwitchListTile(
                                        title: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            ListCreationController
                                                    .to.isPublic.value
                                                ? 'Public'
                                                : 'Private',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),

                                        value: ListCreationController
                                            .to.isPublic.value,

                                        dense: true,
                                        activeColor: Color.fromARGB(
                                            255,
                                            195,
                                            231,
                                            255), // Color of the switch when ON
                                        activeTrackColor: Color.fromARGB(255,
                                            67, 92, 109), // Track color when ON
                                        inactiveThumbColor: Color.fromARGB(
                                            255,
                                            211,
                                            211,
                                            211), // Color of the switch when OFF
                                        inactiveTrackColor: Color.fromARGB(
                                            255,
                                            117,
                                            117,
                                            117), // Track color when OFF

                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        contentPadding: EdgeInsets.only(
                                            right: 12, bottom: 6),
                                        onChanged: (value) {
                                          ListCreationController
                                              .to.isPublic.value = value;
                                        },
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
                ElevatedButton(
                  onPressed: () => _cancel(),
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    elevation: WidgetStateProperty.all(3),
                    shadowColor: WidgetStateProperty.all(Colors.black),
                    foregroundColor: WidgetStateProperty.all(Colors.black),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    overlayColor: WidgetStateProperty.all(
                      Color.fromARGB(255, 196, 231, 255),
                    ),
                  ),
                  child: Row(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.arrow_back_rounded,
                        size: 20,
                        color: Colors.black87,
                      ),
                      Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                // Create / Save button
                ElevatedButton(
                  onPressed: () => _createOrSave(),
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    elevation: WidgetStateProperty.all(3),
                    shadowColor: WidgetStateProperty.all(Colors.black),
                    foregroundColor: WidgetStateProperty.all(Colors.black),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    overlayColor: WidgetStateProperty.all(
                      Color.fromARGB(255, 196, 231, 255),
                    ),
                  ),
                  child: Row(
                    // Optical styling adjustment for different button state
                    spacing: ListCreationController.to.isEditMode.value ? 4 : 0,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ListCreationController.to.isEditMode.value
                            ? 'Save List'
                            : 'Create List',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        ListCreationController.to.isEditMode.value
                            ? Icons.save
                            : Icons.add,
                        size: ListCreationController.to.isEditMode.value
                            ? 18
                            : 22,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
