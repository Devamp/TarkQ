import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';
import 'package:tark_q/components/nav-bar.dart';
import 'package:tark_q/globals.dart';
import 'package:tark_q/views/navbar-views/profile-page.dart';

class TicketView extends StatelessWidget {
  final Map<String, dynamic> ticketData;

  const TicketView({super.key, required this.ticketData});

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
            color: Colors.white,
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
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget buildTicketDetails(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'General',
              style: TextStyle(
                color: Colors.lightGreenAccent,
                fontSize: isTablet(context) ? 40 : 28,
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
              'Created At',
              getFormattedDate(ticketData['createdAt']),
              context,
            ),
            SizedBox(height: 10),
            Text(
              'Raid Info',
              style: TextStyle(
                color: Colors.lightGreenAccent,
                fontSize: isTablet(context) ? 40 : 28,
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
                fontSize: isTablet(context) ? 40 : 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            formField(
              Icons.contacts,
              'Contact Method',
              ticketData['contactMethod'],
              context,
            ),
            formField(
              Icons.person_add,
              'Username',
              ticketData['contactId'],
              context,
            ),
            SizedBox(height: 30),
            userServices.userData?['username'] == ticketData['username']
                ? Center(
                  child: ElevatedButton(
                    onPressed:
                        () async => {
                          await userServices.deleteUserTicket(
                            userServices.getUserEmail(),
                            ticketData['ticketId'],
                          ),
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => NavBar()),
                          ),
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

  String getFormattedDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';

    final localDateTime = timestamp.toDate().toLocal();
    final formatter = DateFormat('MMM d, y \'at\' h:mm a');
    return formatter.format(localDateTime);
  }
}
