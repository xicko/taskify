import 'package:flutter/material.dart';
import 'package:taskify/controllers/base_controller.dart';

class FirstPageErrorIndicatorBuilder extends StatelessWidget {
  const FirstPageErrorIndicatorBuilder({super.key});

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
                    image: AssetImage('assets/visuals/vis2.png'),
                  ),
                  Text(
                    'Please log in to\ncreate a new list',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      elevation: WidgetStateProperty.all(0),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                      ),
                      shadowColor: WidgetStateProperty.all(Colors.black),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),
                      ),
                      backgroundColor: WidgetStateProperty.all(
                        Color.fromARGB(40, 0, 0, 0),
                      ),
                      foregroundColor: WidgetStateProperty.all(Colors.black),
                    ),
                    onPressed: () {
                      BaseController.to.currentNavIndex.value = 2;
                    },
                    child: Text(
                      'Log in',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
