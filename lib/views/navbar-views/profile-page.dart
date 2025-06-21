import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:tark_q/views/login-page.dart';
import '../../components/raid-ticket.dart';
import '../../globals.dart';
import '../../services/user-services.dart';

final UserServices userServices = UserServices.instance;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

Widget buildProfileHeader(BuildContext context) {
  String username = userServices.getUsername();

  return Padding(
    padding: EdgeInsets.all(isTablet(context) ? 10 : 5),
    child: Container(
      color: Colors.black,
      child: Column(
        children: [
          ProfilePicture(
            name: userServices.getUsername().toString().toUpperCase(),
            radius: isTablet(context) ? 70 : 60,
            fontsize: isTablet(context) ? 44 : 40,
          ),
          SizedBox(height: 10),
          Text(
            username,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTablet(context) ? 32 : 24,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed:
                () => {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.grey.shade200,
                        title: Text('Are you sure?'),
                        titleTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: isTablet(context) ? 26 : 22,
                        ),
                        content: Text(
                          'You will be logged out.',
                          style: TextStyle(
                            fontSize: isTablet(context) ? 20 : 14,
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: isTablet(context) ? 22 : 16,
                              ),
                            ),
                            onPressed: () {
                              userServices.signOutUser();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
                          ),
                          TextButton(
                            child: Text(
                              'No',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: isTablet(context) ? 22 : 16,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(
                horizontal: isTablet(context) ? 60 : 40,
                vertical: isTablet(context) ? 10 : 5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: IntrinsicWidth(
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.black,
                    size: isTablet(context) ? 26 : 22,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: isTablet(context) ? 24 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withAlpha(75),
                  width: 1.0,
                ),
              ),
            ),
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(isTablet(context) ? 20 : 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Tickets',
                    style: TextStyle(
                      color: Colors.lightGreenAccent,
                      fontSize: isTablet(context) ? 28 : 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'These are your active tickets.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isTablet(context) ? 20 : 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ProfileState extends State<Profile> {
  Future<List<Map<String, dynamic>>> _loadRaidTickets() async {
    await userServices.loadUserOnLogin();

    final rawList = await userServices.fetchUserRaidTickets(
      userServices.getUserEmail(),
    );

    // Ensure type safety by casting each item
    return rawList.map((e) => e).toList();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _loadRaidTickets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final data = snapshot.data ?? [];

            final List<dynamic> allTickets = [];
            for (var doc in data) {
              final tickets = doc['tickets'] ?? [];
              allTickets.addAll(tickets);
            }

            return Column(
              children: [
                buildProfileHeader(context), // Fixed top header
                const SizedBox(height: 10),
                Expanded(
                  // This makes only the ticket list scrollable
                  child:
                      allTickets.isEmpty
                          ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "You have no active raid tickets.",
                                style: TextStyle(
                                  color: Colors.lightGreenAccent,
                                  fontSize: isTablet(context) ? 26 : 18,
                                ),
                              ),
                            ),
                          )
                          : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                            ),
                            itemCount: allTickets.length,
                            itemBuilder: (context, index) {
                              return RaidTicket(data: allTickets[index]);
                            },
                          ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
