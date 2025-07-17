import 'package:flutter/material.dart';
import 'package:tark_q/components/nav-bar.dart';
import '../globals.dart';

class WelcomeIntro extends StatelessWidget {
  const WelcomeIntro({super.key});

  Widget welcomeModule(IconData icon, String text, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.lightGreenAccent.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.lightGreenAccent,
            size: isTablet(context) ? 50 : 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet(context) ? 22 : 16,
                fontWeight: FontWeight.w500,
                height: 1.4,
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
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.black87],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.waving_hand_rounded,
                      color: Colors.lightGreenAccent,
                      size: 30,
                    ),
                  ],
                ),

                const SizedBox(height: 5),
                const Divider(
                  color: Colors.grey,
                  thickness: 2.0,
                  indent: 75,
                  endIndent: 75,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        welcomeModule(
                          Icons.add,
                          "Get started by clicking the + button on the home page to create your first raid ticket.",
                          context,
                        ),
                        welcomeModule(
                          Icons.public,
                          "Visit the Looking for Raid page to view active raid tickets from other users to find your next squad!",
                          context,
                        ),
                        welcomeModule(
                          Icons.person,
                          "You can view/delete your active raid tickets and account info under the profile page.",
                          context,
                        ),
                        welcomeModule(
                          Icons.verified_outlined,
                          "Show off your achievements from the profile page.",
                          context,
                        ),
                        welcomeModule(
                          Icons.build_circle_outlined,
                          "This app is under continuous development.",
                          context,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const NavBar()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Let\'s Go',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_right_alt, size: 28),
                    ],
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
