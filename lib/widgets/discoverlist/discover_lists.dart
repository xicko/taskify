import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/controllers/auth_controller.dart';
import 'package:taskify/controllers/base_controller.dart';
import 'package:taskify/controllers/list_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/screens/list_details_page.dart';
import 'package:taskify/widgets/discoverlist/report_list.dart';
// import 'package:taskify/widgets/discoverlist/discover_list_skeleton_loader.dart';
import 'package:taskify/widgets/discoverlist/searchbar_discoverlist.dart';
import 'package:taskify/widgets/snackbar.dart';

class DiscoverLists extends StatelessWidget {
  const DiscoverLists({super.key});

  Future<void> _pullToRefresh() async {
    ListController.to.publicPagingController.refresh();
    ListController.to.searchDiscoverController.clear();
  }

  // Share list url
  void _shareList(Map<String, dynamic> item) {
    Share.share('https://taskify.xicko.co/?list=${item['id']}');
  }

  @override
  Widget build(BuildContext context) {
    // getting user's device screen height/width
    double screenHeight = MediaQuery.of(context).size.height;
    double screenwidth // ignore: unused_local_variable
        = MediaQuery.of(context).size.width;

    return Obx(
      () => AnimatedOpacity(
        opacity: ListController.to.isNewListModalVisible.value ||
                UIController.to.listDetailPageOpen.value
            ? 0
            : 1,
        duration: Duration(milliseconds: 300),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),

          /// Skeleton Loader is overlaid over the real list
          child: Stack(
            children: [
              // List UI
              Column(
                children: [
                  // Search
                  SearchBarDiscoverList(),

                  // Mapped lists
                  SizedBox(
                    height: screenHeight * 0.595,
                    child: RefreshIndicator(
                      backgroundColor: Color.fromARGB(210, 66, 66, 66),
                      color: Colors.white,
                      onRefresh: _pullToRefresh,
                      child: PagedListView(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 40, top: 1),
                        scrollController:
                            ListController.to.listDiscoverScrollController,
                        pagingController:
                            ListController.to.publicPagingController,
                        builderDelegate:
                            PagedChildBuilderDelegate<Map<String, dynamic>>(
                          animateTransitions: true,
                          transitionDuration: Duration(milliseconds: 150),
                          itemBuilder: (context, item, index) {
                            // bool isFirst = index == 0;
                            bool isLast = index ==
                                ListController.to.publicPagingController
                                        .itemList!.length -
                                    1;

                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 1),
                              child: GestureDetector(
                                onTap: () {
                                  UIController.to.listDetailPageOpen.value =
                                      true;
                                  debugPrint(UIController
                                      .to.listDetailPageOpen.value
                                      .toString());

                                  // Unfocus (dismiss keyboard)
                                  FocusManager.instance.primaryFocus?.unfocus();

                                  // Open page
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return ListDetailsPage(list: item);
                                      },
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        // Animation beginning and ending curve
                                        const begin = Offset(0, 1);
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOutQuad;

                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        var offsetAnimation =
                                            animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: isLast
                                        ? Radius.circular(16)
                                        : Radius.zero,
                                    bottomRight: isLast
                                        ? Radius.circular(16)
                                        : Radius.zero,
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
                                            mainAxisSize: MainAxisSize.min,
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

                                        // Not rendering report is list is users own list
                                        if (item['user_id'] !=
                                            AuthService().getCurrentUserId())
                                          CustomSlidableAction(
                                            padding: EdgeInsets.only(
                                              top: 4,
                                              bottom: 4,
                                            ),
                                            onPressed: (_) => {
                                              if (AuthController
                                                  .to.isLoggedIn.value)
                                                {
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) => ReportList(
                                                        list: item['id']),
                                                  ),
                                                }
                                              else
                                                {
                                                  CustomSnackBar(context)
                                                      .show('Not logged in.')
                                                }
                                            },
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 247, 98, 88),
                                            foregroundColor: Colors.black,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.report,
                                                  size: 24,
                                                ),
                                                Text(
                                                  'Report',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      // Outer padding
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 4),
                                      child: Padding(
                                        // Inner padding
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 14,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Left side: Title and content
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // Title
                                                      Text(
                                                        item['title'] ??
                                                            'Error',
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        ),
                                                      ),

                                                      SizedBox(height: 6),

                                                      // User email and icon
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .person_outline_rounded,
                                                            size: 18,
                                                            color: Colors
                                                                .blueGrey[600],
                                                          ),
                                                          SizedBox(width: 4),
                                                          ConstrainedBox(
                                                            // Capping width for user email and showing ellipsis for overflow
                                                            constraints:
                                                                BoxConstraints(
                                                                    maxWidth:
                                                                        110),
                                                            child: Text(
                                                              '${item['email']?.split('@').first ?? 'No user'}',
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                        .blueGrey[
                                                                    800],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                SizedBox(width: 15),

                                                // Right side: Created date and user info
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
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[900],
                                                      ),
                                                    ),

                                                    SizedBox(height: 8),
                                                  ],
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 6),

                                            // List Content Text
                                            Text(
                                              item['content'] ?? 'Error',
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[800],
                                              ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
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
                                            elevation:
                                                WidgetStateProperty.all(0),
                                            shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(6),
                                                ),
                                              ),
                                            ),
                                            shadowColor:
                                                WidgetStateProperty.all(
                                                    Colors.black),
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
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
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          firstPageProgressIndicatorBuilder: (context) =>
                              Center(
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
            ],
          ),
        ),
      ),
    );
  }
}
