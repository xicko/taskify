import 'package:flutter/material.dart';
import 'package:taskify/controllers/list_controller.dart';

class HomeButtons extends StatefulWidget {
  const HomeButtons({super.key});

  @override
  State<HomeButtons> createState() => _HomeButtonsState();
}

class _HomeButtonsState extends State<HomeButtons> {
  late double animTurns = 0.0;

  void _refresh() async {
    setState(() {
      animTurns++;
    });

    // Letting the animation go 50% before starting refresh
    await Future.delayed(Duration(milliseconds: 500));

    // Turn off searchmode if already on, then refresh after
    if (ListController.to.isMySearchMode.value) {
      await Future.delayed(Duration(milliseconds: 100));
      ListController.to.isMySearchMode.value = false;
      ListController.to.searchMyController.clear();
      await Future.delayed(Duration(milliseconds: 100));
      ListController.to.pagingController.refresh();
    }

    // Refreshing list pagingcontroller and clearing search input
    ListController.to.pagingController.refresh();
    ListController.to.searchMyController.clear();

    // Resetting the scrollbar to the top
    ListController.to.listMyScrollController.jumpTo(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 14,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Add more buttons with same style
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

        // New List button
        ElevatedButton(
          onPressed: () async {
            ListController.to.addNewList(context);
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
