import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/controllers/auth_controller.dart';
import 'package:taskify/controllers/base_controller.dart';
import 'package:taskify/controllers/lists_controller.dart';
import 'package:taskify/controllers/list_creation_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/screens/list_details_page.dart';
import 'package:taskify/theme/colors.dart';
// import 'package:taskify/widgets/mylist/my_list_skeleton_loader.dart';
import 'package:taskify/widgets/mylist/searchbar_mylist.dart';
import 'package:taskify/widgets/snackbar.dart';

class MyLists extends StatelessWidget {
  const MyLists({super.key});

  // Refresh list
  Future<void> _pullToRefresh() async {
    ListsController.to.pagingController.refresh();
    ListsController.to.searchMyController.clear();
  }

  // List item OnTap func
  void _listOnTap(BuildContext context, Map<String, dynamic> item) {
    UIController.to.listDetailPageOpen.value = true;
    debugPrint(UIController.to.listDetailPageOpen.value.toString());

    // Unfocus (dismiss keyboard)
    FocusManager.instance.primaryFocus?.unfocus();

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

  // List item delete
  void _listDelete(
      BuildContext context, Map<String, dynamic> item, int index) async {
    if (AuthService().getCurrentUserId().toString() == item['user_id']) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
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
            actions: [
              // Cancel Button
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.bw100(Theme.of(context).brightness),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              // Delete button
              GestureDetector(
                onTap: () async {
                  // Unfocusing elements(TextField) if nav index is changed
                  FocusManager.instance.primaryFocus?.unfocus();

                  // Closing dialog
                  Navigator.of(context).pop();

                  // Deleting list
                  ListsController.to.deleteList(context, item['id']);
                  await Future.delayed(Duration(milliseconds: 100));

                  // Showing deleted message
                  if (context.mounted) {
                    CustomSnackBar(context).show('List deleted');
                  }
                  await Future.delayed(Duration(milliseconds: 500));

                  // Removing from the list UI
                  final items = ListsController.to.pagingController.itemList;
                  if (items != null && index >= 0 && index < items.length) {
                    // Remove only if 3 safety checks above are met
                    items.removeAt(index);

                    // Notify the PagingController about the change
                    ListsController.to.pagingController.itemList =
                        List.of(items);
                  }

                  // ??
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      color: AppColors.dialogDeleteBtn(
                          Theme.of(context).brightness),
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
  }

  // Share list url
  void _shareList(Map<String, dynamic> item) {
    Share.share('https://taskify.xicko.co/?list=${item['id']}');
  }

  // Main UI
  @override
  Widget build(BuildContext context) {
    // getting user's device screen height/width
    double screenHeight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;

    return Obx(
      () => AnimatedOpacity(
        opacity: ListCreationController.to.isNewListModalVisible.value ||
                UIController.to.listDetailPageOpen.value
            ? 0
            : 1,
        duration: Duration(milliseconds: 300),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          // Wrapped in obx for the skeleton loader
          child: Obx(
            // Skeleton Loader is overlaid over the real list
            () => // List UI
                Column(
              children: [
                // Search
                SearchBarMyList(),

                // Mapped lists
                SizedBox(
                  height: screenHeight * 0.595,
                  child: RefreshIndicator(
                    backgroundColor: Color.fromARGB(210, 66, 66, 66),
                    color: Colors.white,
                    onRefresh: _pullToRefresh,
                    child: PagedListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollController:
                          ListsController.to.listMyScrollController,
                      pagingController: ListsController.to.pagingController,
                      padding: EdgeInsets.only(
                        bottom: AuthController.to.isLoggedIn.value ? 40 : 0,
                        top: 1,
                      ),
                      builderDelegate:
                          PagedChildBuilderDelegate<Map<String, dynamic>>(
                        animateTransitions: true,
                        transitionDuration: Duration(milliseconds: 150),
                        itemBuilder: (context, item, index) {
                          // bool isFirst = index == 0;
                          bool isLast = index ==
                              ListsController
                                      .to.pagingController.itemList!.length -
                                  1;
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 1),
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
                                      backgroundColor: const Color.fromARGB(
                                          255, 210, 210, 210),
                                      foregroundColor: Colors.black,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                      backgroundColor: const Color.fromARGB(
                                          255, 247, 98, 88),
                                      foregroundColor: Colors.black,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                  onTap: () => _listOnTap(context, item),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                        DateTime.parse(item[
                                                                'created_at'])
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
                                                      color:
                                                          Colors.blueGrey[700],
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
                          );
                        },
                        noItemsFoundIndicatorBuilder: (context) => Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 1),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 0,
                                children: [
                                  Column(
                                    spacing: 16,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                        width: screenwidth * 0.5,
                                        height: screenwidth * 0.5,
                                        image: AssetImage(
                                            'assets/visuals/vis1.png'),
                                      ),
                                      Text(
                                        'No lists found,\nyou can create one!',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // if not authenticated
                        firstPageErrorIndicatorBuilder: (context) => Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 1),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 0,
                                children: [
                                  Column(
                                    spacing: 16,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                        width: screenwidth * 0.5,
                                        height: screenwidth * 0.5,
                                        image: AssetImage(
                                            'assets/visuals/vis2.png'),
                                      ),
                                      Text(
                                        'Please log in to\ncreate a new list',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          elevation: WidgetStateProperty.all(0),
                                          shape: WidgetStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(6),
                                              ),
                                            ),
                                          ),
                                          shadowColor: WidgetStateProperty.all(
                                              Colors.black),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          padding: WidgetStateProperty.all(
                                            EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 0),
                                          ),
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                            Color.fromARGB(40, 0, 0, 0),
                                          ),
                                          foregroundColor:
                                              WidgetStateProperty.all(
                                                  Colors.black),
                                        ),
                                        onPressed: () {
                                          BaseController
                                              .to.currentNavIndex.value = 2;
                                        },
                                        child: Text(
                                          'Log in',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      SizedBox(height: 0),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
