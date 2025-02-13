import 'dart:convert';

import 'package:fleather/fleather.dart' as frmt;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/controllers/avatar_controller.dart';
import 'package:taskify/controllers/list_creation_controller.dart';
import 'package:taskify/controllers/list_detail_controller.dart';
import 'package:taskify/theme/colors.dart';
import 'package:taskify/theme/theme.dart';
import 'package:taskify/widgets/dialogs/user_profile_dialog.dart';
import 'package:taskify/widgets/list_details/top_bar.dart';

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
  @override
  void initState() {
    super.initState();

    // Load list
    ListDetailController.to
        .loadDocument(widget.list['content'])
        .then((document) {
      setState(() {
        ListDetailController.to.listDetailContentController =
            frmt.FleatherController(document: document);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
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
            child: TopBar(list: widget.list),
          ),

          // List body
          body: Padding(
            padding: EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // List title
                        SelectableText(
                          widget.list['title'] ?? 'No Title',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color:
                                AppColors.bw100(Theme.of(context).brightness),
                          ),
                        ),

                        // List content
                        frmt.FleatherTheme(
                          data: MediaQuery.of(context).platformBrightness ==
                                  Brightness.light
                              ? lightFleather
                              : darkFleather,
                          child: frmt.FleatherEditor(
                            scrollPhysics: BouncingScrollPhysics(),
                            focusNode: ListDetailController.to.contentFocusNode,
                            autocorrect: false,
                            scrollable: true,
                            readOnly: true,
                            showCursor: false,
                            padding: EdgeInsets.only(bottom: 8),
                            controller: ListDetailController
                                .to.listDetailContentController,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4),

                // List date
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

                SizedBox(height: 10),

                // User email and icon
                if (widget.list['user_id'] != AuthService().getCurrentUserId())
                  InkWell(
                    onTap: () {
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (_) => UserProfileDialog(list: widget.list),
                      );
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4,
                      children: [
                        FutureBuilder<String>(
                          future: AvatarController.to
                              .fetchUserProfilePic(widget.list['user_id']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                                child: Image(
                                  image: AssetImage('assets/avatar.png'),
                                  width: 28,
                                  height: 28,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                                child: Image(
                                  image: AssetImage('assets/avatar.png'),
                                  width: 28,
                                  height: 28,
                                ),
                              );
                            } else if (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data!.isNotEmpty) {
                              return ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                                child: Image.memory(
                                  base64Decode(snapshot.data!),
                                  width: 28,
                                  height: 28,
                                ),
                              );
                            } else {
                              return ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                                child: Image(
                                  image: AssetImage('assets/avatar.png'),
                                  width: 28,
                                  height: 28,
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${widget.list['email']?.split('@').first ?? 'No user'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color:
                                AppColors.bw100(Theme.of(context).brightness),
                          ),
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
