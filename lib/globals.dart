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
    default:
      return Icon(
        Icons.not_interested,
        color: Colors.amberAccent,
        size: 40,
      ); // Fallback to Material
  }
}
