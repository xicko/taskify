import 'package:flutter/material.dart';
import 'package:taskify/controllers/lists_controller.dart';
import 'package:taskify/widgets/snackbar.dart';

class SearchBarDiscoverList extends StatelessWidget {
  const SearchBarDiscoverList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            // Search Input
            Expanded(
              child: TextField(
                controller: ListsController.to.searchDiscoverController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) {
                  // only search if input is not empty
                  if (ListsController.to.searchMyController.text.isNotEmpty) {
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
              valueListenable: ListsController.to.searchDiscoverController,
              builder: (context, value, child) {
                return ListsController
                        .to.searchDiscoverController.text.isNotEmpty
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
                            ListsController.to.searchDiscoverController.clear();
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
                    .to.searchDiscoverController.text.isNotEmpty) {
                  CustomSnackBar(context).show('Searching...');
                  ListsController.to.searchDiscoverLists();
                }

                // Dismiss textfields focus
                FocusManager.instance.primaryFocus?.unfocus();
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
    );
  }
}
