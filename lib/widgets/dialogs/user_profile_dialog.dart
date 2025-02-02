import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:taskify/controllers/avatar_controller.dart';
import 'package:taskify/theme/colors.dart';

class UserProfileDialog extends StatelessWidget {
  final Map<String, dynamic> list;

  const UserProfileDialog({
    super.key,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FutureBuilder<String>(
            future: AvatarController.to.fetchUserProfilePic(list['user_id']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ClipRRect(
                  child: Image(
                    image: AssetImage('assets/avatar.png'),
                    width: screenWidth,
                    height: screenWidth,
                  ),
                );
              } else if (snapshot.hasError) {
                return ClipRRect(
                  child: Image(
                    image: AssetImage('assets/avatar.png'),
                    width: screenWidth,
                    height: screenWidth,
                  ),
                );
              } else if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty) {
                return ClipRRect(
                  child: Image.memory(
                    base64Decode(snapshot.data!),
                    width: screenWidth,
                    height: screenWidth,
                    fit: BoxFit.cover,
                  ),
                );
              } else {
                return ClipRRect(
                  child: Image(
                    image: AssetImage('assets/avatar.png'),
                    width: screenWidth,
                    height: screenWidth,
                  ),
                );
              }
            },
          ),
          Text(
            list['email'].toString().split('@').first,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 0,
              color: AppColors.bw100(Theme.of(context).brightness),
            ),
          )
        ],
      ),
    );
  }
}
