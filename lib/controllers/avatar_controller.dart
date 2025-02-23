import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'dart:io' as io;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskify/auth/auth_service.dart';

class AvatarController extends GetxController {
  static AvatarController get to => Get.find();

  RxBool hasProfilePic = false.obs;

  // Store raw base64 images
  var currentBase64 = ''.obs;
  var newBase64 = ''.obs;

  RxMap<String, String> userProfile = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfilePic();

    // Listener to change hasProfilePic bool based on currentBase6 length
    ever((currentBase64), (_) {
      hasProfilePic.value = currentBase64.value.isNotEmpty;
    });
  }

  // Used to display new profile pic in UI when uploading image, until inserted to supabase table
  Uint8List newPic() {
    if (newBase64.value.isNotEmpty) {
      final decoded = base64Decode(newBase64.value);
      return decoded;
    }
    // Return an empty list if newBase64 is empty
    return Uint8List(0);
  }

  // Used to display new profile pic in Image.memory() throughout the app UI
  Uint8List currentPic() {
    if (currentBase64.value.isNotEmpty) {
      final decoded = base64Decode(currentBase64.value);
      return decoded;
    }
    // Return an empty list if currentBase64 is empty
    return Uint8List(0);
  }

  // Clear pfp state
  void clearPic() {
    newBase64.value = '';
    currentBase64.value = '';
    hasProfilePic.value = false;
  }

  // Insert / update pfp
  Future<void> addUpdateProfilePic() async {
    final supabase = Supabase.instance.client;

    await supabase.from('profile_pictures').upsert({
      'user_id': AuthService().getCurrentUserId(),
      'base64': newBase64.toString(),
    });
    debugPrint('pfp added/updated');
  }

  // Delete pfp
  Future<void> deleteProfilePic() async {
    final supabase = Supabase.instance.client;

    await supabase
        .from('profile_pictures')
        .delete()
        .eq('user_id', AuthService().getCurrentUserId().toString());

    fetchProfilePic();
  }

  // Fetch pfp
  Future<void> fetchProfilePic() async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('profile_pictures')
        .select('base64')
        .eq('user_id', AuthService().getCurrentUserId().toString())
        .maybeSingle();

    currentBase64.value = response?['base64'] ?? '';
  }

  // Fetch pfp based on user's ID
  Future<String> fetchUserProfilePic(String userId) async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('profile_pictures')
        .select('base64')
        .eq('user_id', userId)
        .maybeSingle();

    return response?['base64'] ?? '';
  }

  // Method to request photo storage permission
  void requestPhotoPermission(Function call) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    if (await Permission.photos.isGranted ||
        await Permission.storage.isGranted) {
      // If perm granted
      call();
    } else {
      // If not granted yet, request permission
      if (androidInfo.version.sdkInt <= 32) {
        // Permission access for Android 12 and below
        await Permission.storage.request();
        if (await Permission.photos.isGranted ||
            await Permission.storage.isGranted) {
          call();
        }
      } else {
        // Permission access for Android 13 and above
        await Permission.photos.request();
        if (await Permission.photos.isGranted ||
            await Permission.storage.isGranted) {
          call();
        }
      }
    }
  }

  // Method to pick image from gallery and crop
  void pickImage() async {
    final ImagePicker picker = ImagePicker();

    // Picked image
    final XFile? pickedImg =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImg == null) return;

    // Method to crop picked image to square
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedImg.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          statusBarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Color.fromARGB(255, 69, 128, 167),
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
    if (croppedFile == null) return;

    // Convert CroppedFile to XFile
    XFile croppedXFile = XFile(croppedFile.path);

    // Finally process the picked image
    processImage(croppedXFile);
  }

  // Method to convert and store the raw image
  void processImage(XFile? pickedImg) async {
    // If image is picked
    if (pickedImg != null) {
      // Picked image
      final originalFile = io.File(pickedImg.path);
      debugPrint('Picked image path: ${pickedImg.path}');

      // Converting to Uint8List, check the file size before decoding to ensure it's valid
      final imageBytes = await originalFile.readAsBytes();
      debugPrint('Original image byte size: ${imageBytes.length} bytes');

      // Decode the image bytes to image object
      final img.Image? decodedImage = img.decodeImage(imageBytes);

      // If decoded image is valid
      if (decodedImage != null) {
        debugPrint(
            'Decoded img res: ${decodedImage.width}x${decodedImage.height}');

        // Resize the image
        final img.Image resizedImage = img.copyResize(
          decodedImage,
          width: 300,
          height: 300,
        );
        debugPrint(
            'Resized img res: ${resizedImage.width}x${resizedImage.height}');

        // Convert the resized image to PNG bytes
        final List<int> resizedBytes = img.encodePng(resizedImage);
        debugPrint('Resized image byte size: ${resizedBytes.length} bytes');

        // Convert the resized image to Base64 string and store in getx state
        final String base64String = base64Encode(resizedBytes);
        AvatarController.to.newBase64.value = base64String;

        // Check if Base64 string is not empty
        if (base64String.isNotEmpty) {
          debugPrint(AvatarController.to.newBase64.value);
        } else {
          debugPrint('Base64 string is empty!');
        }
      } else {
        debugPrint('Failed to decode the image!');
      }
    } else {
      // If no image is picked
      debugPrint('No image picked!');
    }
  }
}
