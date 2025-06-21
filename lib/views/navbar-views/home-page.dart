import 'package:flutter/material.dart';
import 'package:tark_q/components/raid-ticket.dart';
import 'package:tark_q/services/user-services.dart';

import '../../globals.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final UserServices userServices = UserServices.instance;

  Future<List<Map<String, dynamic>>> _loadRaidTickets() async {
    await userServices.loadUserOnLogin();

    final rawList = await userServices.fetchRaidTickets(
      userServices.getUserEmail(),
    );

    // Ensure type safety by casting each item
    return rawList.map((e) => e).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          // data = List<Map<String, dynamic>>
          final List<dynamic> allTickets = [];

          for (var doc in data) {
            final tickets = doc['tickets'] ?? [];
            allTickets.addAll(tickets);
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child:
                  allTickets.isEmpty
                      ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "Could not find any raid tickets.",
                            style: TextStyle(
                              color: Colors.lightGreenAccent,
                              fontSize: isTablet(context) ? 24 : 18,
                            ),
                          ),
                        ),
                      )
                      : Column(
                        children:
                            allTickets.map((entry) {
                              return RaidTicket(data: entry);
                            }).toList(),
                      ),
            ),
          );
        },
      ),
    );
  }
}
