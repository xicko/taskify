import 'package:flutter/material.dart';
import 'package:taskify/controllers/list_controller.dart';
import 'package:taskify/theme/colors.dart';
import 'package:taskify/widgets/mylist/searchbar_mylist.dart';

class MyListSkeletonLoader extends StatelessWidget {
  const MyListSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBarMyList(),
        Container(
          color: AppColors.scaffold(Theme.of(context).brightness),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.595,
            child: ListView.builder(
              padding: EdgeInsets.only(
                bottom: 40, // Adjust padding based on your conditions
                top: 1,
              ),

              // Items to show
              itemCount: ListController.to.isMySearchMode.value ? 1 : 10,
              itemBuilder: (context, index) {
                bool isFirst = index == 0;
                bool isLast = index == 9;

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 1),
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: isFirst ? Radius.circular(0) : Radius.zero,
                          topRight: isFirst ? Radius.circular(0) : Radius.zero,
                          bottomLeft: isLast
                              ? Radius.circular(16)
                              : ListController.to.isMySearchMode.value
                                  ? Radius.circular(16)
                                  : Radius.zero,
                          bottomRight: isLast
                              ? Radius.circular(16)
                              : ListController.to.isMySearchMode.value
                                  ? Radius.circular(16)
                                  : Radius.zero,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left side: Title and content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title placeholder
                                  SkeletonList(width: 200, height: 16),
                                  SizedBox(height: 14),
                                  // Content placeholder
                                  SkeletonList(width: 150, height: 14),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            // Right side: Date and Privacy
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Date placeholder
                                SkeletonList(width: 60, height: 12),
                                SizedBox(height: 8),
                                // Privacy status placeholder
                                Row(
                                  children: [
                                    SkeletonList(width: 40, height: 12),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.lock_rounded,
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
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class SkeletonList extends StatelessWidget {
  final double width;
  final double height;

  SkeletonList({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 233, 233, 233),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
