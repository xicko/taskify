import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:taskify/controllers/list_selection_controller.dart';
import 'package:taskify/widgets/dialogs/delete_selected_lists_dialog.dart';
import 'package:taskify/widgets/dialogs/visibility_change_dialog.dart';
import 'package:taskify/widgets/snackbar.dart';

class SelectionBar extends StatefulWidget {
  const SelectionBar({super.key});

  @override
  State<SelectionBar> createState() => _SelectionBarState();
}

class _SelectionBarState extends State<SelectionBar> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black12,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 10,
                  blurRadius: 20,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                spacing: 4,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side buttons
                  Row(
                    children: [
                      // Cancel selection button
                      IconButton(
                        onPressed: () =>
                            ListSelectionController.to.closeSelectionBar(),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black38,
                          foregroundColor: Colors.white,
                        ),
                        icon: Icon(Icons.close_rounded),
                      ),

                      // Select all button
                      IconButton(
                        onPressed: () => ListSelectionController.to.selectAll(),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black38,
                          foregroundColor: Colors.white,
                        ),
                        icon: Obx(
                          () => SvgPicture.asset(
                            ListSelectionController.to.allSelected.value
                                ? 'assets/svg/select_all_filled.svg'
                                : 'assets/svg/select_all.svg',
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Right side buttons
                  Row(
                    spacing: 3,
                    children: [
                      // Visibility control button
                      ElevatedButton(
                        onPressed: () {
                          if (ListSelectionController
                              .to.selectedLists.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return VisibilityChangeDialog();
                              },
                            );
                          } else {
                            CustomSnackBar(context)
                                .show('Please select a list');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black38,
                          foregroundColor: Colors.white,
                          iconColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(100),
                              bottomLeft: Radius.circular(100),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Row(
                          spacing: 4,
                          children: [
                            Icon(
                              Icons.public_rounded,
                              size: 16,
                            ),
                            Text(
                              'Visibility',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),

                      // Delete all button
                      ElevatedButton(
                        onPressed: () {
                          if (ListSelectionController
                              .to.selectedLists.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DeleteSelectedListsDialog();
                              },
                            );
                          } else {
                            CustomSnackBar(context)
                                .show('Please select a list');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black38,
                          foregroundColor: Colors.white,
                          iconColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(100),
                              bottomRight: Radius.circular(100),
                            ),
                          ),
                          padding: EdgeInsets.only(left: 12, right: 20),
                        ),
                        child: Row(
                          spacing: 4,
                          children: [
                            Icon(
                              Icons.delete_forever,
                              size: 18,
                            ),
                            Text(
                              'Delete',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
