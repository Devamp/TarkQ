import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:tark_q/views/achievements-page.dart';
import '../../components/award-container.dart';
import '../../components/raid-ticket.dart';
import '../../globals.dart';
import '../../services/user-services.dart';

final UserServices userServices = UserServices.instance;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<List<String?>> getUserAchievements() async {
    try {
      return userServices.getUserAchievements(userServices.getUserEmail());
    } catch (e) {
      rethrow;
    }
  }

  Widget buildProfileHeader(BuildContext context) {
    String username = userServices.getUsername();

    return FutureBuilder<List<String?>>(
      future: getUserAchievements(),
      builder: (context, snapshot) {
        final userAchievements = snapshot.data ?? [];

        return Padding(
          padding: EdgeInsets.all(isTablet(context) ? 15 : 10),
          child: Container(
            color: Colors.black,
            child: Column(
              children: [
                ProfilePicture(
                  name: username.toUpperCase(),
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
                  child: Row(
                    children: [
                      Text(
                        'Achievements',
                        style: TextStyle(
                          color: Colors.lightGreenAccent,
                          fontSize: isTablet(context) ? 28 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.grey,
                          size: isTablet(context) ? 36 : 20,
                        ),
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AchievementsPage(),
                            ),
                          );
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                userAchievements.whereType<String>().isEmpty
                    ? Text(
                      'No achievements selected',
                      style: TextStyle(color: Colors.grey),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          userAchievements
                              .where((achievement) => achievement != "None")
                              .map((achievement) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0,
                                  ),
                                  child: AwardContainer(
                                    icon: getAchievementIconByText(
                                      achievement!,
                                    ),
                                    iconText: achievement,
                                    screenName: "Profile",
                                  ),
                                );
                              })
                              .toList(),
                    ),
                SizedBox(height: 12),
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
                    padding: EdgeInsets.all(isTablet(context) ? 20 : 5),
                    child: Text(
                      'Active Tickets',
                      style: TextStyle(
                        color: Colors.lightGreenAccent,
                        fontSize: isTablet(context) ? 28 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
