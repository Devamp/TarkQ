import 'package:flutter/material.dart';
import 'package:tark_q/views/ticket-view.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../globals.dart';

class RaidTicket extends StatefulWidget {
  const RaidTicket({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  State<RaidTicket> createState() => _RaidTicketState();
}

class _RaidTicketState extends State<RaidTicket> {
  Widget buildInfoContent(
    Widget icon,
    String iconText,
    BuildContext context, [
    Color? iconColor,
  ]) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
      child: Row(
        children: [
          icon,
          SizedBox(width: 5),
          Text(
            iconText,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: isTablet(context) ? 26 : 16,
              color: iconColor ?? Colors.white,
            ),
          ),
          SizedBox(width: 5),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isTablet(context) ? 10 : 5,
        horizontal: isTablet(context) ? 15 : 10,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isTablet(context) ? 10 : 5,
          horizontal: isTablet(context) ? 10 : 5,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(25),
          border: Border(
            bottom: BorderSide(color: Colors.lightGreenAccent, width: 1.0),
            top: BorderSide(color: Colors.lightGreenAccent, width: 1.0),
            left: BorderSide(color: Colors.lightGreenAccent, width: 1.0),
            right: BorderSide(color: Colors.lightGreenAccent, width: 1.0),
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Column(
            children: [
              Row(
                children: [
                  ProfilePicture(
                    name: widget.data['username'][0].toString().toUpperCase(),
                    radius: isTablet(context) ? 28 : 20,
                    fontsize: isTablet(context) ? 26 : 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    widget.data['username'],
                    style: TextStyle(
                      color: Colors.lightGreenAccent,
                      fontSize: isTablet(context) ? 30 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  buildInfoContent(
                    Icon(
                      Icons.leaderboard,
                      color: Colors.white,
                      size: isTablet(context) ? 28 : 20,
                    ),
                    "Lv" + widget.data['pmcLevel'],
                    context,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                // main container
                child: Row(
                  // column container
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            buildInfoContent(
                              Icon(
                                Icons.shield_outlined,
                                color: Colors.white,
                                size: isTablet(context) ? 28 : 20,
                              ),
                              widget.data['pmcFaction'],
                              context,
                            ),
                            buildInfoContent(
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: isTablet(context) ? 28 : 20,
                              ),
                              widget.data['map'],
                              context,
                            ),
                            buildInfoContent(
                              Icon(
                                Icons.diversity_3_rounded,
                                color: Colors.white,
                                size: isTablet(context) ? 28 : 20,
                              ),
                              widget.data['maxPartySize'],
                              context,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            buildInfoContent(
                              Icon(
                                Icons.flag,
                                color: Colors.white,
                                size: isTablet(context) ? 28 : 20,
                              ),
                              widget.data['goal'],
                              context,
                            ),
                            buildInfoContent(
                              widget.data['contactMethod'] == "Discord"
                                  ? Icon(
                                    Icons.discord,
                                    color: Colors.white,
                                    size: isTablet(context) ? 28 : 20,
                                  )
                                  : Icon(
                                    Icons.contacts,
                                    color: Colors.white,
                                    size: isTablet(context) ? 28 : 20,
                                  ),
                              widget.data['contactMethod'],
                              context,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: isTablet(context) ? 250 : 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                TicketView(ticketData: widget.data),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          const begin = Offset(1.0, 0.0); // From right
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          final tween = Tween(
                            begin: begin,
                            end: end,
                          ).chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 300),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet(context) ? 40 : 20,
                      vertical: isTablet(context) ? 10 : 5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove_red_eye_sharp,
                        color: Colors.black,
                        size: isTablet(context) ? 22 : 16,
                      ),
                      SizedBox(width: 5),
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
      ),
    );
  }
}
