import 'package:flutter/material.dart';

class NoItemsFoundIndicatorBuilder extends StatelessWidget {
  const NoItemsFoundIndicatorBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    // getting user's device screen height/width
    double screenwidth = MediaQuery.of(context).size.width;

    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 1),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 0,
            children: [
              Column(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    width: screenwidth * 0.5,
                    height: screenwidth * 0.5,
                    image: AssetImage('assets/visuals/vis1.png'),
                  ),
                  Text(
                    'No lists found,\nyou can create one!',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
