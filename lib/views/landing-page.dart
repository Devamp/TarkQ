import 'package:flutter/material.dart';
import 'package:tark_q/globals.dart';
import 'package:tark_q/views/login-page.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 40),
              child: Row(
                children: [
                  Icon(
                    Icons.crop_rotate_sharp,
                    color: Colors.lightGreenAccent,
                    size: isTablet(context) ? 55 : 28,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Maved\nSoftware',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.lightGreenAccent,
                      fontSize: isTablet(context) ? 50 : 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Row(
                children: [
                  Icon(
                    Icons.my_location,
                    color: Colors.lightGreenAccent,
                    size: isTablet(context) ? 120 : 70,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'TarkQ',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.lightGreenAccent,
                      fontSize: isTablet(context) ? 150 : 70,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Solo raids end here.',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet(context) ? 55 : 28,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' Connect with skilled sherpas or find fellow PMCs for your next Tarkov mission.',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.normal,
                        fontSize: isTablet(context) ? 50 : 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ElevatedButton(
                onPressed:
                    () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Login()),
                      ),
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: IntrinsicWidth(
                  child: Row(
                    children: [
                      Text(
                        'DEPLOY',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: isTablet(context) ? 40 : 28,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                        size: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
