import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/controllers/auth_controller.dart';
import 'package:taskify/controllers/base_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/db/database.dart';

class ListCreationController extends GetxController {
  static ListCreationController get to => Get.find();

  // NewListModal input controllers
  final TextEditingController titleController = TextEditingController();
  // final TextEditingController contentController = TextEditingController();
  FleatherController fleatherContentController = FleatherController();
  RxBool isFleatherEmpty = false.obs;

  RxBool isNewListModalVisible = false.obs;
  RxBool isEditMode = false.obs; // Modal editmode
  RxBool isPublic = false.obs; // Modal isPublic toggle

  // For NewListModal editmode
  RxnString? editListId = RxnString(); // ID of the list to be edited
  RxnString? editTitle = RxnString(); // Title of the list to be edited
  RxnString? editContent = RxnString(); // Content of the list to be edited
  RxnBool? editIsPublic = RxnBool(); // Is the list public?

  // temp storing lists in db
  RxList fromDb = [].obs;

  @override
  void onInit() {
    super.onInit();

    // Fetch from local db at startup
    ehlul();

    // Reactive listener for editmode
    ever(editListId!, (_) {
      isEditMode.value = editListId?.value != null;
    });

    fleatherContentController.addListener(() {
      isFleatherEmpty.value =
          fleatherContentController.plainTextEditingValue.text.length < 2;
    });
  }

  // List Methods
  void addNewList() async {
    // Prompt login/signup if not already authenticated
    if (AuthController.to.isLoggedIn.value == false) {
      // Open me screen login/signup if user isnt authenticated
      await Future.delayed(Duration(milliseconds: 300));
      BaseController.to.changePage(2);

      UIController.to.getSnackbar('Not logged in', '', hideMessage: true);
    } else {
      // Clear the modal upon open if user was previously editing another list
      if (editListId?.value != null && editListId!.value!.isNotEmpty) {
        clearControllers();
        isPublic.value = false;
        clearEditData();
        debugPrint('Modal Cleared');
      } else {
        // Modal will not be cleared if working on creating a new list - saves the input texts
        debugPrint('Not cleared');
      }

      BaseController.to.showNewListModal();
    }
  }

  // Method to create a new list
  Future<void> createList(String title, String content, bool isPublic) async {
    try {
      var userId = AuthService().getCurrentUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      await Supabase.instance.client.from('todo_lists').insert({
        'user_id': userId,
        'title': title,
        'content': content,
        'is_public': isPublic,
        'created_at': DateTime.now().toUtc().toString(),
        'updated_at': DateTime.now().toUtc().toString(),
        'email': AuthService().getCurrentUserEmail(),
      }).select();

      isNewListModalVisible.value = false;

      UIController.to.getSnackbar('List created!', '', hideMessage: true);
    } catch (e) {
      debugPrint('$e');
    }
  }

  // Update list method
  Future<void> updateList(
      String title, String content, bool isPublic, String listId) async {
    try {
      var userId = AuthService().getCurrentUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      await Supabase.instance.client
          .from('todo_lists')
          .update({
            'title': title,
            'content': content,
            'is_public': isPublic,
            'updated_at': DateTime.now().toUtc().toString(),
          })
          .eq('id', listId)
          .select();

      isNewListModalVisible.value = false;

      UIController.to.getSnackbar('List updated!', '', hideMessage: true);
    } catch (e) {
      debugPrint('$e');
    }
  }

  void clearControllers() {
    titleController.clear();
    fleatherContentController.clear();
  }

  void clearEditData() {
    editListId?.value = null;
    editTitle?.value = '';
    editContent?.value = '';
    editIsPublic?.value = false;
  }

  @override
  void onClose() {
    // titleController.dispose();
    // fleatherContentController.dispose();

    super.onClose();
  }

  // Inserting to db
  final database = AppDatabase();
  Future<void> insertDb() async {
    await database.into(database.listItems).insert(ListItemsCompanion.insert(
          userId: AuthController.to.userId.value,
          title: titleController.text,
          content: fleatherContentController.plainTextEditingValue.text,
          email: AuthController.to.userEmail.value,
        ));
  }

  // Fetch from local db
  void ehlul() async {
    List allItems = await database.select(database.listItems).get();

    fromDb.assignAll(allItems);
  }
}
