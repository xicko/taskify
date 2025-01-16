import 'package:get/get.dart';

class UIController extends GetxController {
  static UIController get to => Get.find();

  RxBool isSnackbarVisible = false.obs;

  // flag to track if list_details_page is open, does NOT control visibility.
  RxBool listDetailPageOpen = false.obs;

  // Login/Signup Modals
  RxBool loginVisibility = false.obs; // flag to track if login modal is visible
  RxBool signupVisibility =
      false.obs; // flag to track if signup modal is visible
}
