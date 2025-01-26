import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/controllers/auth_controller.dart';
import 'package:taskify/controllers/report_controller.dart';
import 'package:taskify/theme/colors.dart';
import 'package:taskify/widgets/snackbar.dart';

class ReportList extends StatefulWidget {
  final String list;

  const ReportList({super.key, required this.list});

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  final supabase = Supabase.instance.client;

  // Clear all fields
  void _clear() {
    ReportController.to.hatespeech.value = false;
    ReportController.to.spam.value = false;
    ReportController.to.impersonation.value = false;
    ReportController.to.scam.value = false;

    ReportController.to.reasonController.clear();
    ReportController.to.reasonFocusNode.unfocus();
  }

  // Method to insert report to supabase
  Future<void> reportList() async {
    var userId = AuthService().getCurrentUserId();
    var userEmail = AuthService().getCurrentUserEmail();

    if (AuthController.to.isLoggedIn.value) {
      if (ReportController.to.hatespeech.value ||
          ReportController.to.spam.value ||
          ReportController.to.impersonation.value ||
          ReportController.to.scam.value ||
          ReportController.to.reasonController.text.isNotEmpty) {
        await supabase.from('reports').insert({
          'user_id': userId,
          'user_email': userEmail,
          'list_id': widget.list.toString(),
          'hate_speech': ReportController.to.hatespeech.value,
          'spam': ReportController.to.spam.value,
          'impersonation': ReportController.to.impersonation.value,
          'scam': ReportController.to.scam.value,
          'reason': ReportController.to.reasonController.text,
          'created_at': DateTime.now().toUtc().toString(),
        });

        if (mounted) {
          Navigator.pop(context);

          CustomSnackBar(context)
              .show('Your report has been submitted and will be reviewed.');
        }

        _clear();
      } else {
        if (mounted) {
          CustomSnackBar(context)
              .show('Please provide a valid reason or select a category.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = isDarkMode(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      titlePadding: EdgeInsets.only(
        left: 28,
        right: 28,
        top: 24,
        bottom: 4,
      ),
      title: Text(
        'Report list',
        style: TextStyle(
          color: AppColors.bw100(Theme.of(context).brightness),
          fontWeight: FontWeight.w500,
        ),
      ),
      actionsPadding: EdgeInsets.only(
        left: 0,
        right: 0,
        bottom: 0,
      ),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => CheckboxListTile(
                value: ReportController.to.hatespeech.value,
                onChanged: (value) => {
                  ReportController.to.hatespeech.value =
                      !ReportController.to.hatespeech.value
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Text(
                  'Hate Speech',
                  style: TextStyle(
                    color: AppColors.bw100(Theme.of(context).brightness),
                  ),
                ),
              ),
            ),
            Obx(
              () => CheckboxListTile(
                value: ReportController.to.spam.value,
                onChanged: (value) => {
                  ReportController.to.spam.value =
                      !ReportController.to.spam.value
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Text(
                  'Spam',
                  style: TextStyle(
                    color: AppColors.bw100(Theme.of(context).brightness),
                  ),
                ),
              ),
            ),
            Obx(
              () => CheckboxListTile(
                value: ReportController.to.impersonation.value,
                onChanged: (value) => {
                  ReportController.to.impersonation.value =
                      !ReportController.to.impersonation.value
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Text(
                  'Impersonation',
                  style: TextStyle(
                    color: AppColors.bw100(Theme.of(context).brightness),
                  ),
                ),
              ),
            ),
            Obx(
              () => CheckboxListTile(
                value: ReportController.to.scam.value,
                onChanged: (value) => {
                  ReportController.to.scam.value =
                      !ReportController.to.scam.value
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Text(
                  'Scam & Fraud',
                  style: TextStyle(
                    color: AppColors.bw100(Theme.of(context).brightness),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Reason
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: TextField(
            focusNode: ReportController.to.reasonFocusNode,
            controller: ReportController.to.reasonController,
            cursorColor:
                AppColors.textFieldCursorColor(Theme.of(context).brightness),
            style: TextStyle(
              color: AppColors.bw100(Theme.of(context).brightness),
            ),
            maxLength: 100,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'Reason (optional)',
              hintStyle: TextStyle(
                color: AppColors.textFieldHintTextColor(
                    Theme.of(context).brightness),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: AppColors.textFieldBorderColor(
                      Theme.of(context).brightness),
                ),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.black54,
                ),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: AppColors.textFieldBorderColor(
                      Theme.of(context).brightness),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: AppColors.textFieldFocusedBorderColor(
                      Theme.of(context).brightness),
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 12),

        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _clear();
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                    )),
                    elevation: 0,
                    backgroundColor:
                        darkMode ? Colors.grey[800] : Colors.grey[300],
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
                onPressed: () {
                  reportList();
                },
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
                    foregroundColor: Colors.black),
                child: Text(
                  'Submit',
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

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}
