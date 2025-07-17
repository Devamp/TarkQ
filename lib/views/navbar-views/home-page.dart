import 'package:flutter/material.dart';
import 'package:tark_q/views/navbar-views/profile-page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.lightGreenAccent,
                border: Border.all(color: Colors.grey.withAlpha(75)),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Hi ${userServices.getUsername()}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.waving_hand, size: 33, color: Colors.black),
                    ],
                  ),
                  Text(
                    textAlign: TextAlign.start,
                    'Get started quickly by checking out the links below!',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    border: Border.all(color: Colors.grey.withAlpha(75)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 50,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      Text(
                        textAlign: TextAlign.start,
                        'Get started',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.lightGreenAccent,
                    border: Border.all(color: Colors.grey.withAlpha(75)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 50,
                    horizontal: 20,
                  ),
                  child: Column(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
