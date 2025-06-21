import 'package:flutter/material.dart';
import 'package:tark_q/components/nav-bar.dart';

import '../globals.dart';

class WelcomeIntro extends StatelessWidget {
  const WelcomeIntro({super.key});

  Widget welcomeModule(IconData icon, String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.lightGreenAccent,
            size: isTablet(context) ? 55 : 35,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet(context) ? 26 : 15,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.black87],
          ),
        ),
        padding: EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 60),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.lightGreenAccent, width: 1.0),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.waving_hand_rounded,
                      color: Colors.lightGreenAccent,
                      size: 45,
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 2.0,
                  indent: 75,
                  endIndent: 75,
                ),
                SizedBox(height: 5),

                welcomeModule(
                  Icons.add,
                  "Click the + button on the home LFR page to create your raid ticket.",
                  context,
                ),
                welcomeModule(
                  Icons.public,
                  "Visit the Looking for Raid page to view active raid tickets from other users to find your next squad!",
                  context,
                ),
                welcomeModule(
                  Icons.person,
                  "You can view your active raid tickets and account info under the account page.",
                  context,
                ),
                welcomeModule(
                  Icons.star,
                  "Check back for regular updates and improvements.",
                  context,
                ),
                welcomeModule(
                  Icons.build_circle_outlined,
                  "This app is under continuous development.",
                  context,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (context) => NavBar()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: IntrinsicWidth(
                    child: Row(
                      children: [
                        const Text(
                          'LET\'S GO',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.arrow_right, color: Colors.black, size: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
