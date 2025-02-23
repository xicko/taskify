import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controllers/avatar_controller.dart';
import 'package:taskify/widgets/dialogs/profile_picture_edit_dialog.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Obx(
            () => AvatarController.to.currentBase64.value.isNotEmpty
                ? Image.memory(
                    AvatarController.to.currentPic(),
                    height: 160,
                    width: 160,
                  )
                : Image(
                    image: AssetImage('assets/avatar.png'),
                    height: 160,
                    width: 160,
                  ),
          ),
        ),
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Colors.black12,
            minimumSize: Size(60, 60),
            maximumSize: Size(60, 60),
            iconSize: 30,
          ),
          onPressed: () => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => ProfilePictureEditDialog(),
          ),
          icon: Icon(
            Icons.add_photo_alternate_outlined,
          ),
        ),
      ],
    );
  }
}
