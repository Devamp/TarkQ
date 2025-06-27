import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';
import 'package:tark_q/components/nav-bar.dart';
import 'package:tark_q/globals.dart';
import 'package:tark_q/views/navbar-views/profile-page.dart';
import '../components/award-container.dart';

class TicketView extends StatelessWidget {
  final Map<String, dynamic> ticketData;

  const TicketView({super.key, required this.ticketData});

  Future<List<String?>> getUserAchievements() async {
    try {
      return userServices.getUserAchievements(ticketData['userEmail']);
    } catch (e) {
      rethrow;
    }
  }

  Widget formField(
    IconData icon,
    String keyText,
    String valueText,
    BuildContext context,
  ) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: isTablet(context) ? 32 : 22),
        SizedBox(width: 5),
        Text(
          '$keyText:',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: isTablet(context) ? 30 : 17,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 5),
        Text(
          valueText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTablet(context) ? 30 : 17,
            color:
                keyText == "Contact Username"
                    ? Colors.lightGreenAccent
                    : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildTicketHeader(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(isTablet(context) ? 20 : 10),
        child: Column(
          children: [
            ProfilePicture(
              name:
                  ticketData['username'] != null
                      ? ticketData['username'][0].toString().toUpperCase()
                      : 'T',
              radius: isTablet(context) ? 80 : 60,
              fontsize: isTablet(context) ? 65 : 45,
            ),
            SizedBox(height: 10),
            Text(
              ticketData['username'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isTablet(context) ? 36 : 24,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTicketDetails(BuildContext context) {
    return FutureBuilder<List<String?>>(
      future: getUserAchievements(),
      builder: (context, snapshot) {
        final userAchievements = snapshot.data ?? [];

        return Container(
          color: Colors.black,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                userAchievements.whereType<String>().isEmpty
                    ? SizedBox()
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          userAchievements
                              .whereType<String>()
                              .take(4)
                              .where((achievement) => achievement != "None")
                              .map((achievement) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0,
                                  ),
                                  child: AwardContainer(
                                    icon: getAchievementIconByText(achievement),
                                    iconText: achievement,
                                    screenName: "Profile",
                                  ),
                                );
                              })
                              .toList(),
                    ),
                SizedBox(height: 10),
                Text(
                  'General',
                  style: TextStyle(
                    color: Colors.lightGreenAccent,
                    fontSize: isTablet(context) ? 40 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                formField(
                  Icons.contrast,
                  'Faction',
                  ticketData['pmcFaction'],
                  context,
                ),
                formField(
                  Icons.equalizer,
                  'Level',
                  ticketData['pmcLevel'],
                  context,
                ),
                formField(
                  Icons.date_range,
                  'Created',
                  getFormattedDate(ticketData['createdAt']),
                  context,
                ),
                SizedBox(height: 10),
                Text(
                  'Raid Info',
                  style: TextStyle(
                    color: Colors.lightGreenAccent,
                    fontSize: isTablet(context) ? 40 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                formField(
                  Icons.location_on_outlined,
                  'Map',
                  ticketData['map'],
                  context,
                ),
                formField(Icons.flag, 'Goal', ticketData['goal'], context),
                formField(
                  Icons.diversity_3_rounded,
                  'Party Size',
                  ticketData['maxPartySize'],
                  context,
                ),
                SizedBox(height: 10),
                Text(
                  'Contact Info',
                  style: TextStyle(
                    color: Colors.lightGreenAccent,
                    fontSize: isTablet(context) ? 40 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                formField(
                  ticketData['contactMethod'] == "Discord"
                      ? Icons.discord
                      : Icons.contacts,
                  'Contact Method',
                  ticketData['contactMethod'],
                  context,
                ),
                formField(
                  Icons.person_add,
                  'Contact Username',
                  ticketData['contactId'],
                  context,
                ),
                SizedBox(height: 30),
                userServices.userData?['username'] == ticketData['username']
                    ? Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final navigator = Navigator.of(context);

                          await userServices.deleteUserTicket(
                            userServices.getUserEmail(),
                            ticketData['id'],
                          );

                          navigator.pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => NavBar(initialIndex: 1),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet(context) ? 60 : 30,
                            vertical: isTablet(context) ? 20 : 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: IntrinsicWidth(
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_forever,
                                color: Colors.black,
                                size: isTablet(context) ? 30 : 25,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Delete Ticket',
                                style: TextStyle(
                                  fontSize: isTablet(context) ? 30 : 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    : SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket View'),
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: isTablet(context) ? 32 : 20,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            buildTicketHeader(context),
            buildTicketDetails(context),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
