import 'package:flutter/material.dart';
import 'package:taskify/controllers/lists_controller.dart';
import 'package:taskify/controllers/list_creation_controller.dart';

class DiscoverButtons extends StatefulWidget {
  const DiscoverButtons({super.key});

  @override
  State<DiscoverButtons> createState() => _DiscoverButtonsState();
}

class _DiscoverButtonsState extends State<DiscoverButtons> {
  late double animTurns = 0.0;

  void _refresh() async {
    setState(() {
      animTurns++;
    });

    await Future.delayed(Duration(milliseconds: 500));

    // Turn off searchmode if already on, then refresh after
    if (ListsController.to.isDiscoverSearchMode.value) {
      await Future.delayed(Duration(milliseconds: 100));
      ListsController.to.isDiscoverSearchMode.value = false;
      ListsController.to.searchDiscoverController.clear();
      await Future.delayed(Duration(milliseconds: 100));
      ListsController.to.publicPagingController.refresh();
    }

    // Refreshing list pagingcontroller and clearing search input
    ListsController.to.publicPagingController.refresh();
    ListsController.to.searchDiscoverController.clear();

    // Resetting the scrollbar to the top
    ListsController.to.listDiscoverScrollController.jumpTo(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 14,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // add more buttons with same style
        IconButton(
          onPressed: () => _refresh(),
          style: ButtonStyle(
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            elevation: WidgetStateProperty.all(3),
            shadowColor: WidgetStateProperty.all(Colors.black),
            foregroundColor: WidgetStateProperty.all(Colors.black),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
            ),
            backgroundColor: WidgetStateProperty.all(Colors.white),
            overlayColor: WidgetStateProperty.all(
              Color.fromARGB(255, 196, 231, 255),
            ),
          ),
          icon: AnimatedRotation(
            curve: Curves.easeInOutQuad,
            turns: animTurns,
            duration: Duration(seconds: 1),
            child: Icon(
              Icons.refresh_rounded,
              size: 22,
              color: Colors.black87,
            ),
          ),
        ),

        ElevatedButton(
          onPressed: () {
            ListCreationController.to.addNewList(context);
          },
          style: ButtonStyle(
            padding: WidgetStateProperty.all(
              EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            elevation: WidgetStateProperty.all(3),
            shadowColor: WidgetStateProperty.all(Colors.black),
            foregroundColor: WidgetStateProperty.all(Colors.black),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
            ),
            backgroundColor: WidgetStateProperty.all(Colors.white),
            overlayColor: WidgetStateProperty.all(
              Color.fromARGB(255, 196, 231, 255),
            ),
          ),
          child: Row(
            spacing: 0,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'New List',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              Icon(
                Icons.add,
                size: 22,
                color: Colors.black87,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
