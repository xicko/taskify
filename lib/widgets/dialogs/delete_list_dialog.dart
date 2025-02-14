// Delete single list confirmation dialog - my_lists.dart
import 'package:flutter/material.dart';
import 'package:taskify/controllers/lists_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/theme/colors.dart';

class DeleteListDialog extends StatelessWidget {
  final dynamic item;
  final dynamic index;

  const DeleteListDialog({super.key, required this.item, required this.index});

  void _onDelete(BuildContext context) async {
    // Unfocusing elements(TextField) if nav index is changed
    FocusManager.instance.primaryFocus?.unfocus();

    // Closing dialog
    Navigator.of(context).pop();

    // Deleting list
    ListsController.to.deleteList(item['id']);
    await Future.delayed(Duration(milliseconds: 100));

    // Showing deleted message
    UIController.to.getSnackbar('List deleted', '', hideMessage: true);
    await Future.delayed(Duration(milliseconds: 500));

    // Removing from the list UI
    final items = ListsController.to.pagingController.itemList;
    if (items != null && index >= 0 && index < items.length) {
      // Remove only if 3 safety checks above are met
      items.removeAt(index);

      // Notify the PagingController about the change
      ListsController.to.pagingController.itemList = List.of(items);
    }

    // ??
    FocusManager.instance.primaryFocus?.unfocus();
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
