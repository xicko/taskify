// Wrapped PageView in PagedListView since infinite_scroll_pagination package
// doesn't have dedicated horizontal PageView

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:taskify/controllers/avatar_controller.dart';
import 'package:taskify/controllers/list_creation_controller.dart';
import 'package:taskify/controllers/lists_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/screens/sub_screens/list_details_page.dart';

class CarouselListsView extends StatefulWidget {
  final double availableHeight;

  const CarouselListsView({super.key, required this.availableHeight});

  @override
  State<CarouselListsView> createState() => _CarouselListsViewState();
}

class _CarouselListsViewState extends State<CarouselListsView> {
  void onListTap(BuildContext context, Map<String, dynamic> item) {
    UIController.to.listDetailPageOpen.value = true;
    debugPrint(UIController.to.listDetailPageOpen.value.toString());

    // Open page
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ListDetailsPage(list: item);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Animation beginning and ending curve
          const begin = Offset(0, 1);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuad;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedOpacity(
        opacity: ListCreationController.to.isNewListModalVisible.value ||
                UIController.to.listDetailPageOpen.value
            ? 0
            : 1,
        duration: Duration(milliseconds: 300),
        child: Column(
          children: [
            // Top Space
            Obx(
              () => SizedBox(
                  height: ListsController.to.listType.value == 0 ? 2 : 0),
            ),

            // Main Lists
            AnimatedContainer(
              curve: Curves.easeInOutQuad,
              duration: Duration(seconds: 0),
              constraints: BoxConstraints(
                maxHeight: widget.availableHeight - 227,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: PagedListView.separated(
                physics: NeverScrollableScrollPhysics(),
                pagingController: ListsController.to.publicPagingController,
                separatorBuilder: (context, index) => SizedBox(height: 0),
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (BuildContext context, Map<String, dynamic> item,
                      int index) {
                    // Show only 1 PagedListView item
                    if (index >= 1) return SizedBox.shrink();

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: SizedBox(
                            height: widget.availableHeight - 100,
                            child: PageView.builder(
                              physics: BouncingScrollPhysics(),
                              controller: ListsController.to.pageController,
                              onPageChanged: (index) {
                                ListsController.to.pageViewIndex.value = index;
                              },
                              itemCount: ListsController
                                      .to
                                      .publicPagingController
                                      .itemList
                                      ?.length ??
                                  0,
                              itemBuilder: (context, pageIndex) {
                                String content = ListsController.to
                                    .extractPlainText(ListsController
                                            .to
                                            .publicPagingController
                                            .itemList?[pageIndex]['content'] ??
                                        '');

                                String title = ListsController
                                        .to
                                        .publicPagingController
                                        .itemList?[pageIndex]['title'] ??
                                    '';

                                String date = ListsController
                                        .to
                                        .publicPagingController
                                        .itemList?[pageIndex]['updated_at'] ??
                                    'aa';

                                String email = ListsController
                                        .to
                                        .publicPagingController
                                        .itemList?[pageIndex]['email']
                                        ?.split('@')
                                        .first ??
                                    'No user';

                                return InkWell(
                                  onTap: () => onListTap(
                                      context,
                                      ListsController.to.publicPagingController
                                              .itemList?[pageIndex] ??
                                          {}),
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 0),
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Column(
                                        spacing: 8,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // List Title
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 22, right: 22, top: 14),
                                            child: Text(
                                              title,
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),

                                          // User name and pfp
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 22),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                FutureBuilder<String>(
                                                  future: AvatarController.to
                                                      .fetchUserProfilePic(
                                                          ListsController
                                                                          .to
                                                                          .publicPagingController
                                                                          .itemList?[
                                                                      pageIndex]
                                                                  ['user_id'] ??
                                                              ''),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(4),
                                                        ),
                                                        child: Image(
                                                          image: AssetImage(
                                                              'assets/avatar.png'),
                                                          width: 18,
                                                          height: 18,
                                                        ),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(4),
                                                        ),
                                                        child: Image(
                                                          image: AssetImage(
                                                              'assets/avatar.png'),
                                                          width: 18,
                                                          height: 18,
                                                        ),
                                                      );
                                                    } else if (snapshot
                                                            .hasData &&
                                                        snapshot.data != null &&
                                                        snapshot
                                                            .data!.isNotEmpty) {
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(4),
                                                        ),
                                                        child: Image.memory(
                                                          base64Decode(
                                                              snapshot.data!),
                                                          width: 18,
                                                          height: 18,
                                                        ),
                                                      );
                                                    } else {
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(4),
                                                        ),
                                                        child: Image(
                                                          image: AssetImage(
                                                              'assets/avatar.png'),
                                                          width: 18,
                                                          height: 18,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                                SizedBox(width: 4),
                                                ConstrainedBox(
                                                  // Capping width for user email and showing ellipsis for overflow
                                                  constraints: BoxConstraints(
                                                      maxWidth: 110),
                                                  child: Text(
                                                    email,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          Colors.blueGrey[800],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // List Content
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 22,
                                              right: 22,
                                            ),
                                            child: Text(
                                              content,
                                              style: TextStyle(
                                                color: Colors.grey[900],
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),

                                          // List date
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 22,
                                              right: 22,
                                              bottom: 200,
                                            ),
                                            child: Row(
                                              spacing: 8,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.edit_note_rounded,
                                                  size: 16,
                                                  color: Colors.grey[700],
                                                ),
                                                SelectableText(
                                                  ListsController.to.publicPagingController
                                                                      .itemList?[
                                                                  pageIndex]
                                                              ['updated_at'] !=
                                                          null
                                                      ? DateFormat.yMd()
                                                          .add_jm()
                                                          .format(
                                                            DateTime.parse(date)
                                                                .toLocal(),
                                                          )
                                                      : 'Unknown',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
