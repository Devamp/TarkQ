import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

String getFormattedDate(Timestamp? timestamp) {
  if (timestamp == null) return 'Unknown';

  final dateTime = timestamp.toDate().toLocal();
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  } else {
    final formatter = DateFormat('MMM d, y');
    return formatter.format(dateTime);
  }
}

bool isTablet(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final diagonal = sqrt(size.width * size.width + size.height * size.height);
  return diagonal > 1100;
}

Widget getAchievementIconByText(String text) {
  switch (text) {
    case "Kappa":
      return Icon(FontAwesomeIcons.k, color: Colors.amberAccent, size: 30);

    case "Snowball":
      return Icon(FontAwesomeIcons.skull, color: Colors.amberAccent, size: 30);

    case "Killa Hunter":
      return CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 20,
        child: Text(
          '100',
          style: TextStyle(
            color: Colors.amberAccent,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      );

    case "Marathon":
      return Icon(
        FontAwesomeIcons.personRunning,
        color: Colors.amberAccent,
        size: 40,
      );

    case "1 Prestigious":
      return Icon(
        Icons.looks_one_outlined,
        color: Colors.amberAccent,
        size: 40,
      );

    case "2 Prestigious":
      return Icon(
        Icons.looks_two_outlined,
        color: Colors.amberAccent,
        size: 40,
      );

    case "PvE Master":
      return Icon(FontAwesomeIcons.tree, color: Colors.amberAccent, size: 35);

    case "Labs Rat":
      return Icon(Icons.science, color: Colors.amberAccent, size: 35);

    case "Gunsmith":
      return Icon(FontAwesomeIcons.wrench, color: Colors.amberAccent, size: 30);

    case "Collector":
      return Icon(
        FontAwesomeIcons.boxOpen,
        color: Colors.amberAccent,
        size: 30,
      );

    case "Quest Master":
      return Icon(
        Icons.assignment_turned_in,
        color: Colors.amberAccent,
        size: 35,
      );

    case "Survivor":
      return Icon(
        FontAwesomeIcons.heartPulse,
        color: Colors.amberAccent,
        size: 30,
      );

    case "Sniper Elite":
      return Icon(
        FontAwesomeIcons.crosshairs,
        color: Colors.amberAccent,
        size: 30,
      );

    case "Boss Hunter":
      return Icon(FontAwesomeIcons.crown, color: Colors.amberAccent, size: 30);

    case "Trader Max":
      return Icon(
        FontAwesomeIcons.handshake,
        color: Colors.amberAccent,
        size: 30,
      );

    case "PMC Slayer":
      return Icon(
        FontAwesomeIcons.skullCrossbones,
        color: Colors.amberAccent,
        size: 30,
      );

    case "Silent Assassin":
      return Icon(
        FontAwesomeIcons.userNinja,
        color: Colors.amberAccent,
        size: 30,
      );

    case "Looter":
      return Icon(FontAwesomeIcons.box, color: Colors.amberAccent, size: 30);

    case "Chad":
      return Icon(FontAwesomeIcons.fire, color: Colors.amberAccent, size: 30);

    default:
      return Icon(Icons.not_interested, color: Colors.amberAccent, size: 40);
  }
}

Widget buildTicketStatus(Timestamp ticketCreatedAt, String screen) {
  final dateTime = ticketCreatedAt.toDate().toLocal();
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  Color iconColor = Colors.grey;

  if (difference.inHours < 1) {
    iconColor = Colors.green;
  } else if (difference.inHours < 5) {
    iconColor = Colors.yellow;
  } else if (difference.inHours < 24) {
    iconColor = Colors.orangeAccent;
  } else {
    iconColor = Colors.redAccent;
  }

  return Icon(Icons.circle, color: iconColor, size: screen == "1" ? 18 : 14);
}
