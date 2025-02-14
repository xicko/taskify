// Delete all user lists confirmation dialog - me_settings.dart
import 'package:flutter/material.dart';
import 'package:taskify/controllers/lists_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/theme/colors.dart';

class DeleteAllListDialog extends StatelessWidget {
  const DeleteAllListDialog({super.key});

  void _onDelete(BuildContext context) async {
    ListsController.to.deleteAllUserLists();
    Navigator.of(context).pop();

    await Future.delayed(Duration(milliseconds: 400));
    ListsController.to.pagingController.refresh();
    ListsController.to.publicPagingController.refresh();

    UIController.to.getSnackbar('Deleted all lists', '', hideMessage: true);
  }

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
        'Are you sure you want to delete all your lists? This action cannot be undone.',
        style: TextStyle(
          color: AppColors.bw100(Theme.of(context).brightness),
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 0,
      ),
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
                onPressed: () => _onDelete(context),
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
