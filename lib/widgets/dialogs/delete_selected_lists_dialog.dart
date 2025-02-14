// Delete selected lists confirmation dialog - selection_bar.dart
import 'package:flutter/material.dart';
import 'package:taskify/controllers/list_selection_controller.dart';
import 'package:taskify/theme/colors.dart';

class DeleteSelectedListsDialog extends StatelessWidget {
  const DeleteSelectedListsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Confirm delete',
        style: TextStyle(
          color: AppColors.bw100(Theme.of(context).brightness),
        ),
      ),
      content: Text(
        'Are you sure you want to delete selected lists? This action cannot be undone.',
        style: TextStyle(
          color: AppColors.bw100(Theme.of(context).brightness),
        ),
      ),
      actionsPadding: EdgeInsets.all(0),
      actions: [
        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cancel btn
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Delete btn
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ListSelectionController.to.deleteSelectedLists();
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
                    backgroundColor: Color.fromARGB(255, 255, 101, 101),
                    foregroundColor: Colors.black),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
