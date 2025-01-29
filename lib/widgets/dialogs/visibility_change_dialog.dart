// List visibility change confirmation dialog - selection_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controllers/list_selection_controller.dart';
import 'package:taskify/theme/colors.dart';

class VisibilityChangeDialog extends StatelessWidget {
  const VisibilityChangeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Change visibility',
        style: TextStyle(
          color: AppColors.bw100(Theme.of(context).brightness),
        ),
      ),
      contentPadding: EdgeInsets.only(
        top: 10,
        bottom: 8,
        left: 26,
        right: 20,
      ),
      content: Text(
        'This action cannot be undone.',
        style: TextStyle(
          fontSize: 0,
          color: AppColors.bw100(Theme.of(context).brightness),
        ),
      ),
      actionsPadding: EdgeInsets.only(
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
      ),
      actions: [
        // Choices
        Obx(
          () => RadioListTile<bool>(
            value: false,
            groupValue: ListSelectionController.to.isPublic.value,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            onChanged: (bool? value) {
              if (value != null) {
                ListSelectionController.to.isPublic.value = false;
              }
            },
            title: Text('Private'),
          ),
        ),
        Obx(
          () => RadioListTile<bool>(
            value: true,
            groupValue: ListSelectionController.to.isPublic.value,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            onChanged: (bool? value) {
              if (value != null) {
                ListSelectionController.to.isPublic.value = true;
              }
            },
            title: Text('Public'),
          ),
        ),

        SizedBox(height: 12),

        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ListSelectionController.to.isPublic.value = false;
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                      ),
                    ),
                    elevation: 0,
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[800]
                            : Colors.grey[300],
                    foregroundColor:
                        AppColors.bw100(Theme.of(context).brightness)),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ListSelectionController.to.visibilitySelectedLists(context);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    elevation: 0,
                    backgroundColor: Color.fromARGB(255, 131, 206, 255),
                    foregroundColor: Colors.black),
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
