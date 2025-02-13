import 'package:flutter/material.dart';
import 'package:taskify/controllers/list_creation_controller.dart';

class CancelButton extends StatefulWidget {
  const CancelButton({super.key});

  @override
  State<CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<CancelButton> {
  void _cancel() {
    // Closing NewListModal
    ListCreationController.to.isNewListModalVisible.value = false;

    // Clearing isPublic toggle on cancel if EditMode was true
    // Basically clearing the toggle for the next time the modal is opened
    if (ListCreationController.to.isEditMode.value) {
      ListCreationController.to.isPublic.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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
    );
  }
}
