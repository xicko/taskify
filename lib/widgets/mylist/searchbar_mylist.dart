import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controllers/list_creation_controller.dart';
import 'package:taskify/controllers/list_selection_controller.dart';
import 'package:taskify/controllers/lists_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';

class SearchBarMyList extends StatelessWidget {
  const SearchBarMyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: ListCreationController.to.isNewListModalVisible.value ||
                UIController.to.listDetailPageOpen.value
            ? 0
            : 1,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  // Search Input
                  Expanded(
                    child: TextField(
                      enabled: true,
                      controller: ListsController.to.searchMyController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) {
                        // only search if input is not empty
                        if (ListsController
                            .to.searchMyController.text.isNotEmpty) {
                          UIController.to.getSnackbar('Searching...', '',
                              hideMessage: true);
                          ListsController.to.searchMyLists();
                        }
                      },
                      //onChanged: (value) async {
                      //  await Future.delayed(Duration(seconds: 1));
                      //  ListController.to.searchLists();
                      //},
                      cursorColor: Colors.black,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.black87),
                        filled: true,
                        fillColor: Colors.transparent,
                        contentPadding: EdgeInsets.only(
                          top: 12,
                          bottom: 12,
                          left: 16,
                          right: 4,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  // Clear input button
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: ListsController.to.searchMyController,
                    builder: (context, value, child) {
                      return ListsController
                              .to.searchMyController.text.isNotEmpty
                          ? SizedBox(
                              width: 25,
                              height: 25,
                              child: IconButton(
                                iconSize: 18,
                                padding: EdgeInsets.zero,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.transparent,
                                ),
                                onPressed: () {
                                  // Clear text controller
                                  ListsController.to.searchMyController.clear();

                                  // Clear & Close selection mode
                                  ListSelectionController.to
                                      .closeSelectionBar();
                                },
                                icon: Icon(
                                  Icons.clear_rounded,
                                  size: 18,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : SizedBox(); // Empty SizedBox when no text
                    },
                  ),

                  SizedBox(width: 8),

                  // Search button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: Colors.black,
                      backgroundColor: Color.fromARGB(255, 143, 210, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          topLeft: Radius.circular(6),
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                      ),
                      padding: EdgeInsets.only(
                        top: 4,
                        bottom: 4,
                      ),
                    ),
                    onPressed: () {
                      // Button only active if input is not empty
                      if (ListsController
                          .to.searchMyController.text.isNotEmpty) {
                        UIController.to
                            .getSnackbar('Searching...', '', hideMessage: true);
                        ListsController.to.searchMyLists();
                      }
                    },
                    child: Row(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 24,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
