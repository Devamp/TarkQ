import 'package:flutter/material.dart';
import 'package:tark_q/views/ticket-view.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import '../globals.dart';

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

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isTablet(context) ? 10 : 8,
        horizontal: isTablet(context) ? 15 : 12,
      ),
      child: Container(
        padding: EdgeInsets.all(isTablet(context) ? 10 : 10),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(25),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.lightGreenAccent),
        ),
        child: Column(
          children: [
            // Header Row
            Row(
              children: [
                ProfilePicture(
                  name: data['username'][0].toUpperCase(),
                  radius: isTablet(context) ? 28 : 20,
                  fontsize: isTablet(context) ? 26 : 16,
                ),
                const SizedBox(width: 8),
                Text(
                  data['username'],
                  style: TextStyle(
                    color: Colors.lightGreenAccent,
                    fontSize: isTablet(context) ? 30 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                buildInfoRow(Icons.leaderboard, "Lv${data['pmcLevel']}"),
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
                        buildInfoRow(Icons.shield_outlined, data['pmcFaction']),
                        buildInfoRow(
                          Icons.diversity_3_rounded,
                          data['maxPartySize'],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        buildInfoRow(Icons.flag, data['goal']),
                        buildInfoRow(contactIcon, data['contactMethod']),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Button
            SizedBox(
              width: isTablet(context) ? 250 : 175,
              child: ElevatedButton(
                onPressed: navigateToTicketView,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet(context) ? 40 : 15,
                    vertical: isTablet(context) ? 10 : 5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.remove_red_eye_sharp,
                      size: isTablet(context) ? 22 : 16,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: isTablet(context) ? 22 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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
}
