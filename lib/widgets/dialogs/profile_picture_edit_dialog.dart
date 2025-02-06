import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controllers/avatar_controller.dart';
import 'package:taskify/theme/colors.dart';
import 'package:taskify/widgets/snackbar.dart';

class ProfilePictureEditDialog extends StatelessWidget {
  const ProfilePictureEditDialog({super.key});

  // Save Changes btn
  void _onSave(BuildContext context) async {
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
  }

  // Remove current pic btn
  void _onRemove(BuildContext context) async {
    await AvatarController.to.deleteProfilePic();
    if (context.mounted) {
      Navigator.pop(context);
      CustomSnackBar(context).show('Picture removed');
    }
    AvatarController.to.newBase64.value = '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      insetPadding: EdgeInsets.all(0),
      title: Column(
        children: [
          // Image Section
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 300,
              maxWidth: double.infinity,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Obx(
                () {
                  var image = AvatarController.to.newBase64.value.isNotEmpty
                      ? Image.memory(
                          AvatarController.to.newPic(),
                          fit: BoxFit.cover,
                        )
                      : AvatarController.to.currentBase64.value.isNotEmpty
                          ? Image.memory(
                              AvatarController.to.currentPic(),
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/avatar.png',
                              fit: BoxFit.cover,
                            );
                  return AspectRatio(
                    // 1:1
                    aspectRatio: 1.0,
                    child: image,
                  );
                },
              ),
            ),
          ),

          SizedBox(height: 20),

          // Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Remove button
              ElevatedButton(
                onPressed: () => _onRemove(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black12,
                  foregroundColor:
                      AppColors.bw100(Theme.of(context).brightness),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(100),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline_outlined,
                      size: 18,
                      color: AppColors.bw100(Theme.of(context).brightness),
                    ),
                    SizedBox(width: 4),
                    Text('Remove',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.bw100(Theme.of(context).brightness),
                        )),
                  ],
                ),
              ),

              SizedBox(width: 2),

              // Add/Change photo button
              ElevatedButton(
                onPressed: () => AvatarController.to.requestPhotoPermission(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black12,
                  foregroundColor:
                      AppColors.bw100(Theme.of(context).brightness),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(100),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 12, right: 20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 18,
                      color: AppColors.bw100(Theme.of(context).brightness),
                    ),
                    SizedBox(width: 4),
                    Text(
                      AvatarController.to.hasProfilePic.value
                          ? 'Change photo'
                          : 'Add photo',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.bw100(Theme.of(context).brightness),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Dialog Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cancel button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    // Clear uploaded pic if cancelled
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
                        AppColors.bw100(Theme.of(context).brightness),
                  ),
                  child: Text('Cancel', style: TextStyle(fontSize: 16)),
                ),
              ),

              // Save button
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _onSave(context),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    elevation: 0,
                    backgroundColor: Color.fromARGB(255, 131, 206, 255),
                    foregroundColor: Colors.black,
                  ),
                  child: Text('Save', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
