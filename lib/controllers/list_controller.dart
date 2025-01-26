import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/controllers/auth_controller.dart';
import 'package:taskify/controllers/base_controller.dart';
import 'package:taskify/controllers/ui_controller.dart';
import 'package:taskify/widgets/snackbar.dart';

class ListController extends GetxController {
  static ListController get to => Get.find();

  // Search
  final TextEditingController searchMyController = TextEditingController();
  final TextEditingController searchDiscoverController =
      TextEditingController();
  RxBool isMySearchMode = false.obs; // Flag to track your lists tab search mode
  RxBool isDiscoverSearchMode =
      false.obs; // Flag to track discover tab search mode

  // NewListModal input controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  RxBool isNewListModalVisible = false.obs;
  RxBool isEditMode = false.obs; // Modal editmode
  RxBool isPublic = false.obs; // Modal isPublic toggle

  // For NewListModal editmode
  RxnString? editListId = RxnString(); // ID of the list to be edited
  RxnString? editTitle = RxnString(); // Title of the list to be edited
  RxnString? editContent = RxnString(); // Content of the list to be edited
  RxnBool? editIsPublic = RxnBool(); // Is the list public?

  // List
  static const int pageSize = 50;
  final RxList<Map<String, dynamic>> userLists = <Map<String, dynamic>>[].obs;
  final PagingController<int, Map<String, dynamic>> pagingController =
      PagingController(firstPageKey: 0);
  final PagingController<int, Map<String, dynamic>> publicPagingController =
      PagingController(firstPageKey: 0);

  // MyList Scrollbar
  final ScrollController listMyScrollController = ScrollController();
  var myScrollbarPosition = 0.0.obs;

  // DiscoverList Scrollbar
  final ScrollController listDiscoverScrollController = ScrollController();
  var discoverScrollbarPosition = 0.0.obs;

  RxBool isListLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener(fetchUserLists);
    publicPagingController.addPageRequestListener(fetchPublicLists);

    // reactive listener for editmode
    ever(editListId!, (_) {
      isEditMode.value = editListId?.value != null;
    });

    // If the search text is empty, turn off search mode
    searchMyController.addListener(() async {
      if (searchMyController.text.isEmpty) {
        await Future.delayed(Duration(milliseconds: 100));
        isMySearchMode.value = false;
        await Future.delayed(Duration(milliseconds: 100));
        pagingController.refresh();
      }
    });

    searchDiscoverController.addListener(() async {
      if (searchDiscoverController.text.isEmpty) {
        await Future.delayed(Duration(milliseconds: 100));
        isDiscoverSearchMode.value = false;
        await Future.delayed(Duration(milliseconds: 100));
        publicPagingController.refresh();
      }
    });

    // My Lists scrollbar listener
    listMyScrollController.addListener(() {
      // Calculate scrollbar position
      final maxScrollExtent = listMyScrollController.position.maxScrollExtent;

      // Ensure maxScrollExtent is not zero to avoid division by zero
      myScrollbarPosition.value = (maxScrollExtent > 0
          ? listMyScrollController.offset / maxScrollExtent
          : 0.0);
    });

    // Discover Lists scrollbar listener
    listDiscoverScrollController.addListener(() {
      // Calculate scrollbar position
      final maxScrollExtent =
          listDiscoverScrollController.position.maxScrollExtent;

      // Ensure maxScrollExtent is not zero to avoid division by zero
      discoverScrollbarPosition.value = (maxScrollExtent > 0
          ? listDiscoverScrollController.offset / maxScrollExtent
          : 0.0);
    });
  }

  // Method to create a new list
  Future<void> createList(
      BuildContext context, String title, String content, bool isPublic) async {
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

      if (context.mounted) {
        CustomSnackBar(context).show('List created!');
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  // Update list method
  Future<void> updateList(BuildContext context, String title, String content,
      bool isPublic, String listId) async {
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

      if (context.mounted) {
        CustomSnackBar(context).show('List updated!');
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  // Delete a list method
  Future<void> deleteList(BuildContext context, String listId) async {
    try {
      var userId = AuthService().getCurrentUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final response = await Supabase.instance.client
          .from('todo_lists')
          .delete()
          .eq('id', listId);

      if (response != null) {
        isNewListModalVisible.value = false;
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  // Delete all user lists method
  Future<void> deleteAllUserLists() async {
    try {
      var userId = AuthService().getCurrentUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      await Supabase.instance.client
          .from('todo_lists')
          .delete()
          .eq('user_id', userId);

      debugPrint('All lists deleted for user: $userId');
    } catch (e) {
      debugPrint('Error deleting all lists: $e');
    }
  }

  // Method to start search
  void searchMyLists() async {
    // My Lists page
    isMySearchMode.value = true;

    await Future.delayed(Duration(seconds: 1));
    pagingController.itemList?.clear(); // Clear current list

    fetchUserLists(0);
  }

  void searchDiscoverLists() {
    // Discover page list
    isDiscoverSearchMode.value = true;
    publicPagingController.itemList?.clear(); // Clear current list

    fetchPublicLists(0);
  }

  // Method to fetch the users own lists
  Future<List<Map<String, dynamic>>> fetchUserLists(int pageKey) async {
    // Executes after the current synchronous code, avoiding interference with widget rendering
    Future.microtask(() => isListLoading.value = true);

    // Little delay before fetching
    await Future.delayed(Duration(milliseconds: 500));

    try {
      // Getting userId
      var userId = AuthService().getCurrentUserId();
      debugPrint('fetchingUser');

      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Custom fetch if searchmode is true
      if (isMySearchMode.value) {
        final response = await Supabase.instance.client
            .from('todo_lists')
            .select()
            .eq('user_id', userId)
            .ilike('title', '%${searchMyController.text}%')
            // Sorting by updated date for now
            .order('updated_at', ascending: false)
            .range(pageKey, pageKey + pageSize - 1);

        final List<Map<String, dynamic>> fetchedLists =
            List<Map<String, dynamic>>.from(response);

        if (fetchedLists.length < pageSize) {
          pagingController.appendLastPage(fetchedLists);
        } else {
          final nextPageKey = pageKey + pageSize;
          pagingController.appendPage(fetchedLists, nextPageKey);
        }
      } else {
        // Regular fetch
        final response = await Supabase.instance.client
            .from('todo_lists')
            .select()
            .eq('user_id', userId)
            // Sorting by updated date for now
            .order('updated_at', ascending: false)
            .range(pageKey, pageKey + pageSize - 1);

        final List<Map<String, dynamic>> fetchedLists =
            List<Map<String, dynamic>>.from(response);

        if (fetchedLists.length < pageSize) {
          pagingController.appendLastPage(fetchedLists);
        } else {
          final nextPageKey = pageKey + pageSize;
          pagingController.appendPage(fetchedLists, nextPageKey);
        }
      }
    } catch (e) {
      debugPrint('$e');
      pagingController.error = e;

      return [];
    } finally {
      Future.microtask(() => isListLoading.value = false);
    }
    return [];
  }

  // Method to export users lists to json and save locally
  Future<void> exportUserLists(BuildContext context, int pageKey) async {
    try {
      // If need to export right from the current data in pagingController use:
      // List<Map<String, dynamic>> lists = pagingController.itemList ?? [];

      // Getting userId
      var userId = AuthService().getCurrentUserId().toString();
      debugPrint('exportFetching');

      // Fetching user's lists
      final response = await Supabase.instance.client
          .from('todo_lists')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final List<Map<String, dynamic>> lists =
          List<Map<String, dynamic>>.from(response);

      List<Map<String, dynamic>> exportData = lists
          .map(
            (list) => {
              'title': list['title'],
              'content': list['content'],
              'created_at': list['created_at'],
              'updated_at': list['updated_at'],
            },
          )
          .toList();

      // Encoding exported list data to json format
      String jsonData = jsonEncode(exportData);

      // If list is empty display message
      if (jsonData.toString().length < 4) {
        // CustomSnackBar(context).show('No lists to export', duration: 1500);
        UIController.to.getSnackbar(
          'No lists to export',
          'Create a list to export',
          shadows: false,
        );
      }

      // Specifying directory
      final appDir = await getDownloadsDirectory();
      final path = '${appDir!.path}/user_lists.json';

      // If json data is more than 4 characters in length proceed to save file
      if (jsonData.toString().length > 4) {
        final file = File(path);
        await file.writeAsString(jsonData);

        // CustomSnackBar(context).show('Lists exported to "$path"', duration: 7500);
        UIController.to.getSnackbar(
          'Export successful',
          'Lists exported to "$path"',
          shadows: false,
          duration: Duration(seconds: 8),
        );
        debugPrint('Lists exported to "$path"');
      }
    } catch (e) {
      debugPrint('Error exporting user lists: $e');
      if (context.mounted) {
        CustomSnackBar(context).show(
          'Unable to save lists, please try again',
          duration: 1500,
        );
      }
    }
  }

  // Method to fetch all public lists
  Future<void> fetchPublicLists(int pageKey) async {
    // Executes after the current synchronous code, avoiding interference with widget rendering
    Future.microtask(() => isListLoading.value = true);

    // Little delay before fetching
    await Future.delayed(Duration(milliseconds: 500));
    debugPrint('fetchingPublic');

    try {
      // Custom fetch if searchmode is true
      if (isDiscoverSearchMode.value) {
        final response = await Supabase.instance.client
            .from('todo_lists')
            .select()
            .eq('is_public', true)
            .ilike('title', '%${searchDiscoverController.text}%')
            // Sorting by updated date for now
            .order('updated_at', ascending: false)
            .range(pageKey, pageKey + pageSize - 1);

        final List<Map<String, dynamic>> fetchedPublicLists =
            List<Map<String, dynamic>>.from(response);

        if (fetchedPublicLists.length < pageSize) {
          publicPagingController.appendLastPage(fetchedPublicLists);
        } else {
          final nextPageKey = pageKey + pageSize;
          publicPagingController.appendPage(fetchedPublicLists, nextPageKey);
        }
      } else {
        // Regular fetch
        final response = await Supabase.instance.client
            .from('todo_lists')
            .select()
            .eq('is_public', true)
            // Sorting by updated date for now
            .order('updated_at', ascending: false)
            .range(pageKey, pageKey + pageSize - 1);

        final List<Map<String, dynamic>> fetchedPublicLists =
            List<Map<String, dynamic>>.from(response);

        if (fetchedPublicLists.length < pageSize) {
          publicPagingController.appendLastPage(fetchedPublicLists);
        } else {
          final nextPageKey = pageKey + pageSize;
          publicPagingController.appendPage(fetchedPublicLists, nextPageKey);
        }
      }
    } catch (e) {
      debugPrint('Error fetching public list: $e');
      publicPagingController.error = e;
    } finally {
      isListLoading.value = false;
    }
  }

  // List Methods
  void addNewList(BuildContext context) async {
    // Prompt login/signup if not already authenticated
    if (AuthController.to.isLoggedIn.value == false) {
      // Open me screen login/signup if user isnt authenticated
      await Future.delayed(Duration(milliseconds: 300));
      BaseController.to.changePage(2);

      if (context.mounted) {
        CustomSnackBar(context).show('Not logged in');
      }
    } else {
      // Clear the modal upon open if user was previously editing another list
      if (editListId?.value != null && editListId!.value!.isNotEmpty) {
        titleController.clear();
        contentController.clear();
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

  void clearEditData() {
    editListId?.value = null;
    editTitle?.value = '';
    editContent?.value = '';
    editIsPublic?.value = false;
  }

  @override
  void onClose() {
    pagingController.dispose();
    publicPagingController.dispose();

    titleController.dispose();
    contentController.dispose();

    listMyScrollController.dispose();
    listDiscoverScrollController.dispose();

    super.onClose();
  }
}
