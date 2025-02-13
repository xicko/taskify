import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controllers/list_creation_controller.dart';

class PrivacyToggle extends StatefulWidget {
  const PrivacyToggle({super.key});

  @override
  State<PrivacyToggle> createState() => _PrivacyToggleState();
}

class _PrivacyToggleState extends State<PrivacyToggle> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => SwitchListTile(
          title: Align(
            alignment: Alignment.centerRight,
            child: Text(
              ListCreationController.to.isPublic.value ? 'Public' : 'Private',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          value: ListCreationController.to.isPublic.value,
          dense: true,
          activeColor:
              Color.fromARGB(255, 195, 231, 255), // Color of the switch when ON
          activeTrackColor:
              Color.fromARGB(255, 67, 92, 109), // Track color when ON
          inactiveThumbColor: Color.fromARGB(
              255, 211, 211, 211), // Color of the switch when OFF
          inactiveTrackColor:
              Color.fromARGB(255, 117, 117, 117), // Track color when OFF

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          contentPadding: EdgeInsets.only(right: 12, bottom: 6),
          onChanged: (value) {
            ListCreationController.to.isPublic.value = value;
          },
        ),
      ),
    );
  }
}
