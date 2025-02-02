import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/controllers/list_selection_controller.dart';
import 'package:taskify/controllers/lists_controller.dart';
import 'package:taskify/controllers/list_creation_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/screens/list_details_page.dart';
import 'package:taskify/widgets/dialogs/delete_list_dialog.dart';
import 'package:taskify/widgets/pagedlistbuilders/first_page_error_indicator_builder.dart';
import 'package:taskify/widgets/pagedlistbuilders/no_items_found_indicator_builder.dart';

class MyLists extends StatelessWidget {
  final dynamic availableHeight;

  const MyLists({super.key, required this.availableHeight});

  // Refresh list
  Future<void> _pullToRefresh() async {
    // Clearing selectionmode when refreshed
    ListSelectionController.to.closeSelectionBar();

    // Clearing controllers
    ListsController.to.pagingController.refresh();
    ListsController.to.searchMyController.clear();
  }

  // List item OnTap func
  void _listOnTap(BuildContext context, Map<String, dynamic> item) {
    UIController.to.listDetailPageOpen.value = true;
    debugPrint(UIController.to.listDetailPageOpen.value.toString());

    // Unfocus (dismiss keyboard)
    FocusManager.instance.primaryFocus?.unfocus();

    // Open list detail page
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

  // List item delete
  void _listDelete(
      BuildContext context, Map<String, dynamic> item, int index) async {
    if (AuthService().getCurrentUserId().toString() == item['user_id']) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteListDialog(item: item, index: index);
        },
      );
    } else {
      null;
    }
  }

  // Share list url
  void _shareList(Map<String, dynamic> item) {
    Share.share('https://taskify.xicko.co/?list=${item['id']}');
  }

  // Main UI
  @override
  Widget build(BuildContext context) {
    // getting user's device screen height/width
    // ignore: unused_local_variable
    double screenwidth = MediaQuery.of(context).size.width;

    return Obx(
      () => AnimatedOpacity(
        opacity: ListCreationController.to.isNewListModalVisible.value ||
                UIController.to.listDetailPageOpen.value
            ? 0
            : 1,
        duration: Duration(milliseconds: 300),
        child: AnimatedContainer(
          curve: Curves.easeInOutQuad,
          duration: Duration(seconds: 0),
          constraints: BoxConstraints(
            maxHeight: availableHeight - 225,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: RefreshIndicator(
              backgroundColor: Color.fromARGB(210, 66, 66, 66),
              color: Colors.white,
              onRefresh: _pullToRefresh,
              child: PagedListView(
                physics: AlwaysScrollableScrollPhysics(),
                scrollController: ListsController.to.listMyScrollController,
                pagingController: ListsController.to.pagingController,
                padding: EdgeInsets.only(top: 1),
                builderDelegate:
                    PagedChildBuilderDelegate<Map<String, dynamic>>(
                  animateTransitions: true,
                  transitionDuration: Duration(milliseconds: 150),
                  itemBuilder: (context, item, index) {
                    // bool isFirst = index == 0;
                    bool isLast = index ==
                        ListsController.to.pagingController.itemList!.length -
                            1;
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 1,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft:
                              isLast ? Radius.circular(16) : Radius.zero,
                          bottomRight:
                              isLast ? Radius.circular(16) : Radius.zero,
                        ),
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              CustomSlidableAction(
                                padding: EdgeInsets.only(
                                  top: 4,
                                  bottom: 4,
                                ),
                                onPressed: (_) => _shareList(item),
                                backgroundColor:
                                    const Color.fromARGB(255, 210, 210, 210),
                                foregroundColor: Colors.black,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 1,
                                  children: [
                                    Icon(
                                      Icons.share,
                                      size: 22,
                                    ),
                                    Text(
                                      'Share',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CustomSlidableAction(
                                padding: EdgeInsets.only(
                                  top: 4,
                                  bottom: 4,
                                ),
                                onPressed: (_) =>
                                    _listDelete(context, item, index),
                                backgroundColor:
                                    const Color.fromARGB(255, 247, 98, 88),
                                foregroundColor: Colors.black,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.delete_forever,
                                      size: 24,
                                    ),
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            // Tap to open list details
                            onTap: () {
                              // Select list if in selectionmode
                              if (ListSelectionController
                                  .to.isSelectionMode.value) {
                                ListSelectionController.to.listOnLongPress(
                                  context,
                                  index,
                                  item['id'],
                                );
                              } else {
                                // Open list details
                                _listOnTap(context, item);
                              }
                            },
                            onLongPress: () => ListSelectionController.to
                                .listOnLongPress(context, index, item['id']),
                            child: Obx(
                              () => Container(
                                decoration: BoxDecoration(
                                  color: ListSelectionController.to
                                          .isSelected(index)
                                      ? Colors.grey[300]
                                      : Colors.white,
                                ),
                                // Outer padding
                                padding: EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 4,
                                ),
                                child: Padding(
                                  // Inner Padding
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 14,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Left side: Title and content
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Title
                                            Text(
                                              item['title'] ?? 'Error',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            // Content
                                            Text(
                                              item['content'] ?? 'Error',
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[900],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      // Right side: Created date and privacy status
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          // Date
                                          Text(
                                            item['created_at'] != null
                                                ? DateFormat.yMd().format(
                                                    DateTime.parse(
                                                            item['created_at'])
                                                        .toLocal())
                                                : 'Error',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[900],
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          // Privacy status
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                item['is_public']
                                                    ? 'Public'
                                                    : 'Private',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blueGrey[700],
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(
                                                item['is_public']
                                                    ? Icons.public_rounded
                                                    : Icons.lock_rounded,
                                                size: 16,
                                                color: Colors.blueGrey[700],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  noItemsFoundIndicatorBuilder: (context) =>
                      NoItemsFoundIndicatorBuilder(),

                  // if not authenticated
                  firstPageErrorIndicatorBuilder: (context) =>
                      FirstPageErrorIndicatorBuilder(),

                  firstPageProgressIndicatorBuilder: (context) => Center(
                    child: CircularProgressIndicator(),
                  ),

                  newPageProgressIndicatorBuilder: (context) => Center(
                    child: CircularProgressIndicator(),
                  ),

                  noMoreItemsIndicatorBuilder: (context) => Center(
                    child: Column(
                      children: [
                        SizedBox(height: 0),
                        Text(
                          'No more lists',
                          style: TextStyle(fontSize: 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
