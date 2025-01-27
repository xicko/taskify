import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/controllers/auth_controller.dart';
import 'package:taskify/controllers/lists_controller.dart';
import 'package:taskify/controllers/list_creation_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/theme/colors.dart';
import 'package:taskify/widgets/discoverlist/report_list.dart';
import 'package:taskify/widgets/snackbar.dart';

class ListDetailsPage extends StatefulWidget {
  final Map<String, dynamic> list;

  const ListDetailsPage({
    super.key,
    required this.list,
  });

  @override
  State<ListDetailsPage> createState() => _ListDetailsPageState();
}

class _ListDetailsPageState extends State<ListDetailsPage> {
  // Share List method
  void shareList() {
    Share.share(
      'https://taskify.xicko.co/?list=${widget.list['id']}',
      subject: widget.list['title'],
    );
  }

  // Main UI
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedOpacity(
        opacity: ListCreationController.to.isNewListModalVisible.value ? 0 : 1,
        duration: Duration(milliseconds: 400),
        child: Scaffold(
          backgroundColor: AppColors.listDetailBG(Theme.of(context).brightness),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Obx(
              () => AnimatedOpacity(
                opacity: ListCreationController.to.isNewListModalVisible.value
                    ? 0
                    : 1,
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
                      debugPrint(
                          UIController.to.listDetailPageOpen.value.toString());
                    },
                  ),

                  backgroundColor:
                      AppColors.listDetailBG(Theme.of(context).brightness),

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
                                    builder: (_) =>
                                        ReportList(list: widget.list['id']),
                                  );
                                } else {
                                  CustomSnackBar(context)
                                      .show('Not logged in.');
                                }
                              },
                              icon: Icon(
                                Icons.report_gmailerrorred_rounded,
                                color: AppColors.bw100(
                                    Theme.of(context).brightness),
                                size: 28,
                              ),
                            ),

                            // Share
                            IconButton(
                              onPressed: () => shareList(),
                              icon: Icon(
                                Icons.share_outlined,
                                color: AppColors.bw100(
                                    Theme.of(context).brightness),
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
                                color: AppColors.bw100(
                                    Theme.of(context).brightness),
                                size: 24,
                              ),
                            ),

                            // Update list button
                            IconButton(
                              onPressed: () {
                                if (AuthService()
                                        .getCurrentUserId()
                                        .toString() ==
                                    widget.list['user_id']) {
                                  ListCreationController.to.editListId?.value =
                                      widget.list['id'];
                                  ListCreationController.to.editTitle?.value =
                                      widget.list['title'];
                                  ListCreationController.to.editContent?.value =
                                      widget.list['content'];
                                  ListCreationController
                                          .to.editIsPublic?.value =
                                      widget.list['is_public'] ?? false;

                                  ListCreationController
                                      .to.isNewListModalVisible.value = true;
                                } else {
                                  null;
                                }
                              },
                              icon: Icon(
                                Icons.edit_outlined,
                                color: AppColors.bw100(
                                    Theme.of(context).brightness),
                                size: 24,
                              ),
                            ),

                            // Delete list button and confirmation dialog
                            IconButton(
                              onPressed: () async {
                                if (AuthService()
                                        .getCurrentUserId()
                                        .toString() ==
                                    widget.list['user_id']) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Confirm delete',
                                          style: TextStyle(
                                            color: AppColors.bw100(
                                                Theme.of(context).brightness),
                                          ),
                                        ),
                                        content: Text(
                                          'Are you sure you want to delete this list?',
                                          style: TextStyle(
                                            color: AppColors.bw100(
                                                Theme.of(context).brightness),
                                          ),
                                        ),
                                        actions: [
                                          // Cancel Button
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 16),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: AppColors.bw100(
                                                      Theme.of(context)
                                                          .brightness),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Delete button
                                          GestureDetector(
                                            onTap: () async {
                                              Navigator.of(context).pop();
                                              ListsController.to.deleteList(
                                                  context, widget.list['id']);
                                              await Future.delayed(
                                                  Duration(milliseconds: 100));
                                              if (context.mounted) {
                                                CustomSnackBar(context)
                                                    .show('List deleted');
                                              }
                                              await Future.delayed(
                                                  Duration(milliseconds: 500));
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                              }
                                              ListsController
                                                  .to.pagingController
                                                  .refresh();
                                              ListsController
                                                  .to.publicPagingController
                                                  .refresh();
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color:
                                                      AppColors.dialogDeleteBtn(
                                                          Theme.of(context)
                                                              .brightness),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  null;
                                }
                              },
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: AppColors.bw100(
                                    Theme.of(context).brightness),
                                size: 24,
                              ),
                            )
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),

          // List body
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  widget.list['title'] ?? 'No Title',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.bw100(Theme.of(context).brightness),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      widget.list['content'] ?? 'No Content Available',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.bw100(Theme.of(context).brightness),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (widget.list['user_id'] != AuthService().getCurrentUserId())
                  SelectableText(
                    'Shared by: ${widget.list['email']?.split('@').first ?? 'Unknown'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.bw100(Theme.of(context).brightness),
                    ),
                  ),
                SizedBox(height: 10),
                Row(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit_note_rounded,
                      size: 18,
                    ),
                    SelectableText(
                      widget.list['updated_at'] != null
                          ? DateFormat.yMd().add_jm().format(
                                DateTime.parse(widget.list['updated_at'])
                                    .toLocal(),
                              )
                          : 'Unknown',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.bw100(Theme.of(context).brightness),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
