import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tark_q/views/navbar-views/profile-page.dart';
import 'package:tark_q/views/ticket-view.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import '../globals.dart';
import 'nav-bar.dart';

class RaidTicket extends StatefulWidget {
  const RaidTicket({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  State<RaidTicket> createState() => _RaidTicketState();
}

class _RaidTicketState extends State<RaidTicket> {
  Widget buildInfoRow(IconData icon, String text) {
    return buildInfoContent(
      Icon(icon, color: Colors.white, size: isTablet(context) ? 28 : 20),
      text,
    );
  }

  Widget buildInfoContent(Widget icon, String text, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: isTablet(context) ? 26 : 16,
              fontWeight: FontWeight.normal,
              color: color ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void navigateToTicketView() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => TicketView(ticketData: widget.data),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.ease)),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final isDiscord = data['contactMethod'] == "Discord";
    final contactIcon = isDiscord ? Icons.discord : Icons.contacts;
    final isUserSelf = data['userEmail'] == userServices.getUserEmail();

    return Container(
      padding: EdgeInsets.all(isTablet(context) ? 10 : 10),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(25),
        border: Border(bottom: BorderSide(color: Colors.grey.withAlpha(75))),
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            children: [
              ProfilePicture(
                name: data['username'][0].toUpperCase(),
                radius: 20,
                fontsize: 16,
              ),
              const SizedBox(width: 8),
              Text(
                data['username'],
                style: TextStyle(
                  color: isUserSelf ? Colors.redAccent : Colors.amberAccent,
                  fontSize: isTablet(context) ? 30 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  buildInfoRow(Icons.leaderboard, "Lv${data['pmcLevel']}"),
                  Text(
                    data['gameMode'] ?? 'PVP',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amberAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Main Info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      buildInfoRow(Icons.my_location, data['map']),
                      buildInfoRow(Icons.flag, data['goal']),
                      buildInfoRow(
                        Icons.diversity_3_rounded,
                        data['maxPartySize'],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      buildInfoRow(
                        Icons.hourglass_bottom_sharp,
                        '${data['userHours'] ?? '< 50'} hours',
                      ),
                      buildInfoRow(contactIcon, data['contactMethod']),
                    ],
                  ),
                  Row(
                    children: [
                      buildInfoRow(Icons.public, data['region'] ?? 'Other'),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: navigateToTicketView,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.remove_red_eye_sharp,
                        size: isTablet(context) ? 22 : 15,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: isTablet(context) ? 22 : 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              userServices.userData?['username'] == data['username']
                  ? Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final navigator = Navigator.of(context);

                        await userServices.deleteUserTicket(
                          userServices.getUserEmail(),
                          data['id'],
                        );
                        navigator.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size.zero,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          Icons.delete_forever,
                          size: 22,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                  : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
