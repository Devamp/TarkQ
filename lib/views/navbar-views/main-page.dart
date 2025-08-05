import 'package:flutter/material.dart';
import 'package:tark_q/components/nav-bar.dart';
import 'package:tark_q/views/achievements-page.dart';
import 'package:tark_q/views/my-tickets.dart';
import 'package:tark_q/views/navbar-views/profile-page.dart';
import '../raid-form.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int? ticketCount = 0;

  @override
  void initState() {
    super.initState();
    loadTicketCount();
  }

  Future<void> loadTicketCount() async {
    final count = await userServices.getTotalActiveTickets();
    setState(() {
      ticketCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    String username = userServices.getUsername();

    return PopScope(
      canPop: false,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF1A1A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBody: true,
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Hi, ',
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.lightGreenAccent,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.waving_hand,
                          color: Colors.lightGreenAccent,
                          size: 32,
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        text: 'There are currently ',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        children: <TextSpan>[
                          TextSpan(
                            text: ticketCount.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.lightGreenAccent,
                            ),
                          ),
                          TextSpan(text: ' PMCs looking for a raid!'),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        GestureDetector(
                          onTap:
                              () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => RaidForm(),
                                ),
                              ),
                          child: Container(
                            width: 285,
                            height: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: Colors.amberAccent,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.newspaper, size: 45),
                                  SizedBox(width: 5),
                                  Text(
                                    'Create Ticket',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ), // Optional spacing between the two containers
                        Expanded(
                          child: GestureDetector(
                            onTap:
                                () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AchievementsPage(),
                                  ),
                                ),
                            child: Container(
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(Icons.emoji_events, size: 50),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => {},
                            child: Container(
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(Icons.notifications, size: 45),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap:
                              () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MyTickets(),
                                ),
                              ),
                          child: Container(
                            width: 285,
                            height: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: Colors.redAccent,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.receipt_long, size: 45),
                                  SizedBox(width: 5),
                                  Text(
                                    'My Tickets',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        GestureDetector(
                          onTap:
                              () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => NavBar(initialIndex: 1),
                                ),
                              ),
                          child: Container(
                            width: 285,
                            height: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: Colors.lightGreenAccent,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.public, size: 45),
                                  SizedBox(width: 5),
                                  Text(
                                    'Browse Tickets',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ), // Optional spacing between the two containers
                        Expanded(
                          child: GestureDetector(
                            onTap:
                                () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => NavBar(initialIndex: 2),
                                  ),
                                ),
                            child: Container(
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(Icons.person, size: 50),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Upcoming Raids',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
