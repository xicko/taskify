import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:taskify/constants/forbidden_words.dart';
import 'package:taskify/controllers/list_creation_controller.dart';
import 'package:taskify/controllers/lists_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';

class CreateSaveButton extends StatefulWidget {
  const CreateSaveButton({super.key});

  @override
  State<CreateSaveButton> createState() => _CreateSaveButtonState();
}

class _CreateSaveButtonState extends State<CreateSaveButton> {
  // Create / edit list
  void _createOrSave() async {
    String title = ListCreationController.to.titleController.text;
    String content = jsonEncode(
        ListCreationController.to.fleatherContentController.document);

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
      UIController.to
          .getSnackbar('List cannot be empty', '', hideMessage: true);
    } else if (ListCreationController.to.isPublic.value &&
        // If ispublic toggle is true, check for forbidden words
        (containsForbiddenWords(title) || containsForbiddenWords(content))) {
      UIController.to.getSnackbar(
          'Inappropriate language is not allowed in public lists.', '',
          hideMessage: true);
    } else {
      if (ListCreationController.to.isEditMode.value == false) {
        // Creation
        //ListCreationController.to.createList(title, content, ListCreationController.to.isPublic.value);

        ListCreationController.to.insertDb();
      } else {
        // Editing
        ListCreationController.to.updateList(
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
      ListCreationController.to.titleController.clear();
      ListCreationController.to.fleatherContentController.clear();
      ListCreationController.to.isPublic.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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
            ListCreationController.to.isEditMode.value ? Icons.save : Icons.add,
            size: ListCreationController.to.isEditMode.value ? 18 : 22,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }
}
