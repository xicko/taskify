import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/controllers/auth_controller.dart';
import 'package:taskify/controllers/list_creation_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/theme/colors.dart';
import 'package:taskify/widgets/dialogs/delete_list_detail_dialog.dart';
import 'package:taskify/widgets/discoverlist/report_list.dart';

class TopBar extends StatefulWidget {
  final Map<String, dynamic> list;

  const TopBar({super.key, required this.list});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  // Share List method
  void shareList() {
    Share.share(
      'https://taskify.xicko.co/?list=${widget.list['id']}',
      subject: widget.list['title'],
    );
  }

  // Edit List method
  void editList() async {
    if (AuthService().getCurrentUserId().toString() == widget.list['user_id']) {
      // Clear controllers before opening
      ListCreationController.to.clearControllers();
      ListCreationController.to.clearEditData();

      // Set edit data
      await Future.delayed(Duration(milliseconds: 20));
      ListCreationController.to.editListId?.value = widget.list['id'];
      ListCreationController.to.editTitle?.value = widget.list['title'];
      ListCreationController.to.editContent?.value = widget.list['content'];
      ListCreationController.to.editIsPublic?.value =
          widget.list['is_public'] ?? false;

      ListCreationController.to.isNewListModalVisible.value = true;
    } else {
      null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedOpacity(
        opacity: ListCreationController.to.isNewListModalVisible.value ? 0 : 1,
        duration: Duration(),
        child: AppBar(
          // Custom back button
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: AppColors.bw100(Theme.of(context).brightness),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              UIController.to.listDetailPageOpen.value = false;
              debugPrint(UIController.to.listDetailPageOpen.value.toString());
            },
          ),

          backgroundColor: AppColors.listDetailBG(Theme.of(context).brightness),

          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'List Details',
                style: TextStyle(
                  color: AppColors.bw100(Theme.of(context).brightness),
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Report and Share button for public list
              if (AuthService().getCurrentUserId().toString() !=
                  widget.list['user_id'])
                Row(
                  children: [
                    // Report
                    IconButton(
                      onPressed: () {
                        if (AuthController.to.isLoggedIn.value) {
                          showDialog(
                            context: context,
                            builder: (_) => ReportList(list: widget.list['id']),
                          );
                        } else {
                          UIController.to.getSnackbar('Not logged in.', '',
                              hideMessage: true);
                        }
                      },
                      icon: Icon(
                        Icons.report_gmailerrorred_rounded,
                        color: AppColors.bw100(Theme.of(context).brightness),
                        size: 28,
                      ),
                    ),

                    // Share
                    IconButton(
                      onPressed: () => shareList(),
                      icon: Icon(
                        Icons.share_outlined,
                        color: AppColors.bw100(Theme.of(context).brightness),
                        size: 24,
                      ),
                    ),
                  ],
                ),

              // Show list edit and delete buttons if user's id match
              if (AuthService().getCurrentUserId().toString() ==
                  widget.list['user_id'])
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Share button for user list
                    IconButton(
                      onPressed: () => shareList(),
                      icon: Icon(
                        Icons.share_outlined,
                        color: AppColors.bw100(Theme.of(context).brightness),
                        size: 24,
                      ),
                    ),

                    // Update list button
                    IconButton(
                      onPressed: () => editList(),
                      icon: Icon(
                        Icons.edit_outlined,
                        color: AppColors.bw100(Theme.of(context).brightness),
                        size: 24,
                      ),
                    ),

                    // Delete list button and confirmation dialog
                    IconButton(
                      onPressed: () async {
                        if (AuthService().getCurrentUserId().toString() ==
                            widget.list['user_id']) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DeleteListDetailDialog(list: widget.list);
                            },
                          );
                        } else {
                          null;
                        }
                      },
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.bw100(Theme.of(context).brightness),
                        size: 24,
                      ),
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
