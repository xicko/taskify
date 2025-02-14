import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/controllers/lists_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';

class ListSelectionController extends GetxController {
  static ListSelectionController get to => Get.find();

  // Flag to track if in selectionmode
  RxBool isSelectionMode = false.obs;

  // Flag to track if individual list is selected
  RxBool isListSelected = false.obs;

  RxBool allSelected = false.obs;

  // Storing list index
  RxSet<int> selectedLists = <int>{}.obs;

  // Storing IDs of selected lists in array
  RxList<String> selectedListId = <String>[].obs;

  RxBool isPublic = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Set allSelected bool to true whenever selectedLists int and pagingController length match
    ever((selectedLists), (_) {
      final itemCount =
          ListsController.to.pagingController.itemList?.length ?? 0;
      allSelected.value = itemCount == selectedLists.length;
    });
  }

  void openSelectionBar() async {
    isSelectionMode.value = true;
    isPublic.value = false;
  }

  void toggleSelectionBar() async {
    if (isSelectionMode.value == false) {
      isSelectionMode.value = true;
      isPublic.value = false;
    } else {
      closeSelectionBar();
    }
  }

  void closeSelectionBar() {
    isSelectionMode.value = false;
    isListSelected.value = false;
    isPublic.value = false;
    allSelected.value = false;

    selectedLists.clear();
    selectedListId.clear();
  }

  void clearSelection() {
    selectedLists.clear();
    selectedListId.clear();
  }

  void listOnLongPress(BuildContext context, int index, String id) {
    openSelectionBar();

    if (selectedLists.contains(index)) {
      selectedLists.remove(index);

      selectedListId.remove(id);
    } else {
      selectedLists.add(index);

      selectedListId.add(id);
    }
  }

  // Select all button
  void selectAll() {
    final itemCount = ListsController.to.pagingController.itemList?.length ?? 0;
    final itemIds = ListsController.to.pagingController.itemList;

    // Converting List<Map<String, dynamic>> to List<String>
    final List<String>? idList = itemIds
        ?.map((item) => item['id']?.toString() ?? '')
        .where((id) => id.isNotEmpty)
        .toList();

    // Select all lists if allSelected is false
    if (allSelected.value == false) {
      selectedLists
          .assignAll(List.generate(itemCount, (index) => index).toSet());
      selectedListId.assignAll(idList ?? []);
    } else {
      // Clear all selection and close selectionmode if all already selected
      clearSelection();
    }
  }

  bool isSelected(int index) {
    return selectedLists.contains(index);
  }

  // Method to delete only selected lists
  Future<void> deleteSelectedLists() async {
    UIController.to.getSnackbar('Deleting lists..', '', hideMessage: true);

    await Future.delayed(Duration(milliseconds: 200));
    await Supabase.instance.client
        .from('todo_lists')
        .delete()
        .eq('user_id', AuthService().getCurrentUserId().toString())
        .inFilter('id', selectedListId);

    await Future.delayed(Duration(milliseconds: 200));
    closeSelectionBar();
    // Removing from the list UI
    ListsController.to.pagingController.refresh();
  }

  // Method to delete only selected lists
  Future<void> visibilitySelectedLists() async {
    UIController.to.getSnackbar('Changing visibility..', '', hideMessage: true);

    await Future.delayed(Duration(milliseconds: 200));
    await Supabase.instance.client
        .from('todo_lists')
        .update({'is_public': isPublic.value})
        .eq('user_id', AuthService().getCurrentUserId().toString())
        .inFilter('id', selectedListId);

    await Future.delayed(Duration(milliseconds: 200));
    closeSelectionBar();
    ListsController.to.pagingController.refresh();
  }
}
