// Delete single list confirmation dialog - list_details_page.dart
import 'package:flutter/material.dart';
import 'package:taskify/controllers/lists_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/theme/colors.dart';

class DeleteListDetailDialog extends StatelessWidget {
  final Map<String, dynamic> list;

  const DeleteListDetailDialog({super.key, required this.list});

  void _onDelete(BuildContext context) async {
    Navigator.of(context).pop();
    ListsController.to.deleteList(list['id']);
    await Future.delayed(Duration(milliseconds: 100));
    UIController.to.getSnackbar('List deleted', '', hideMessage: true);
    await Future.delayed(Duration(milliseconds: 500));
    if (context.mounted) {
      Navigator.pop(context);
    }
    ListsController.to.pagingController.refresh();
    ListsController.to.publicPagingController.refresh();
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
        'Are you sure you want to delete this list?',
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
