import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskify/controllers/base_controller.dart';
import 'package:taskify/theme/colors.dart';

class AboutTaskify extends StatelessWidget {
  const AboutTaskify({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          top: 0,
          left: 32,
          right: 32,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About Taskify',
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.bw100(Theme.of(context).brightness),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Taskify is an open-source to-do list app that allows users to create and manage personal task lists. Users can create private lists by default, with an option to make them public. Lists can be accessed, edited, and organized efficiently.\n\n'
                'The app also allows users to discover public lists created by other users, view their content, and interact with the community.\n\n'
                'This app is built using Flutter and Supabase for the backend. The app is open-source, you can check out the code on GitHub.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.bw100(Theme.of(context).brightness),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Developed by Dashnyam Batbayar',
                style: TextStyle(
                  color: AppColors.bw100(Theme.of(context).brightness),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Open link
                      BaseController.to
                          .openLink('https://github.com/xicko/taskify');
                      ;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.grey[900],
                    ),
                    icon: FaIcon(
                      FontAwesomeIcons.github,
                      color: Colors.black,
                    ),
                    label: Text(
                      'GitHub',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Open link
                      BaseController.to
                          .openLink('https://taskify.dashnyam.com');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.grey[900],
                    ),
                    icon: FaIcon(
                      FontAwesomeIcons.earthAsia,
                      color: Colors.black,
                    ),
                    label: Text(
                      'Website',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
