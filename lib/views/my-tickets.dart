import 'package:flutter/material.dart';

import '../components/raid-ticket.dart';
import 'navbar-views/profile-page.dart';

class MyTickets extends StatefulWidget {
  const MyTickets({super.key});

  @override
  State<MyTickets> createState() => _MyTicketsState();
}

class _MyTicketsState extends State<MyTickets> {
  Future<List<Map<String, dynamic>>> _loadRaidTickets() async {
    final rawList = await userServices.getUserRaidTickets(
      userServices.getUserEmail(),
    );

    return rawList.map((e) => e).toList();
  }

  @override
  Widget build(BuildContext context) {
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
            extendBody: true,
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.person_pin_sharp,
                        color: Colors.lightGreenAccent,
                        size: 35,
                      ),
                      const SizedBox(width: 3),
                      const Text(
                        'My Tickets',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.lightGreenAccent,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        color: Colors.redAccent,
                        icon: const Icon(Icons.cancel_outlined, size: 26),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _loadRaidTickets(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          );
                        }

                        final List<Map<String, dynamic>> allTickets =
                            snapshot.data ?? [];

                        if (allTickets.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.sentiment_dissatisfied_outlined,
                                    color: Colors.lightGreenAccent,
                                    size: 75,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "You have no active raid tickets.",
                                    style: TextStyle(
                                      color: Colors.lightGreenAccent,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: allTickets.length,
                          itemBuilder: (context, index) {
                            return RaidTicket(data: allTickets[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
