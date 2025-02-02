import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controllers/avatar_controller.dart';
import 'package:taskify/theme/colors.dart';
import 'package:taskify/widgets/snackbar.dart';

class ProfilePictureEditDialog extends StatelessWidget {
  const ProfilePictureEditDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.only(top: 16),
      title: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Obx(
            () => AvatarController.to.newBase64.value.isNotEmpty
                ? Image.memory(
                    AvatarController.to.newPic(),
                    height: 260,
                    width: 260,
                  )
                : AvatarController.to.currentBase64.value.isNotEmpty
                    ? Image.memory(
                        AvatarController.to.currentPic(),
                        height: 260,
                        width: 260,
                      )
                    : Image(
                        image: AssetImage('assets/avatar.png'),
                        height: 260,
                        width: 260,
                      ),
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.all(0),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 3,
            children: [
              // Remove
              ElevatedButton(
                onPressed: () async {
                  await AvatarController.to.deleteProfilePic();
                  if (context.mounted) {
                    Navigator.pop(context);
                    CustomSnackBar(context).show('Picture removed');
                  }
                  AvatarController.to.newBase64.value = '';
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black12,
                  foregroundColor:
                      AppColors.bw100(Theme.of(context).brightness),
                  iconColor: AppColors.bw100(Theme.of(context).brightness),
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
                      Icons.delete_outline_outlined,
                      size: 18,
                    ),
                    Text(
                      'Remove',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Add / Change photo
              ElevatedButton(
                onPressed: () => AvatarController.to.requestPhotoPermission(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black12,
                  foregroundColor:
                      AppColors.bw100(Theme.of(context).brightness),
                  iconColor: AppColors.bw100(Theme.of(context).brightness),
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
                      Icons.add_photo_alternate_outlined,
                      size: 18,
                    ),
                    Text(
                      AvatarController.to.hasProfilePic.value
                          ? 'Change photo'
                          : 'Add photo',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Dialog Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  AvatarController.to.newBase64.value = '';
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                      ),
                    ),
                    elevation: 0,
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[800]
                            : Colors.grey[300],
                    foregroundColor:
                        AppColors.bw100(Theme.of(context).brightness)),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  if (AvatarController.to.hasProfilePic.value) {
                    await AvatarController.to.changeProfilePic();
                  } else {
                    await AvatarController.to.addProfilePic();
                  }
                  await Future.delayed(Duration(milliseconds: 100));
                  AvatarController.to.fetchProfilePic();
                  if (context.mounted) {
                    Navigator.pop(context);
                    CustomSnackBar(context).show('Profile picture uploaded');
                  }
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    elevation: 0,
                    backgroundColor: Color.fromARGB(255, 131, 206, 255),
                    foregroundColor: Colors.black),
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
