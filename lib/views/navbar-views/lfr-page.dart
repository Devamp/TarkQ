import 'package:flutter/material.dart';
import 'package:tark_q/components/raid-ticket.dart';
import 'package:tark_q/services/user-services.dart';
import '../../globals.dart';

class LFR extends StatelessWidget {
  final Map<String, String> filters;
  final UserServices userServices = UserServices.instance;

  LFR(this.filters, {super.key});

  Future<List<Map<String, dynamic>>> _loadRaidTickets() async {
    await userServices.loadUserOnLogin();

    final rawList = await userServices.getDisplayRaidTickets(
      userServices.getUserEmail(),
      filters,
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

          final List<Map<String, dynamic>> allTickets = snapshot.data ?? [];

          return SingleChildScrollView(
            child:
                allTickets.isEmpty
                    ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child:
                            filters != {}
                                ? Column(
                                  children: [
                                    Text(
                                      "Could not find any raid tickets",
                                      style: TextStyle(
                                        color: Colors.lightGreenAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: isTablet(context) ? 24 : 18,
                                      ),
                                    ),
                                    Text(
                                      "Try clearing any filters",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: isTablet(context) ? 24 : 14,
                                      ),
                                    ),
                                  ],
                                )
                                : Text(
                                  "Could not find any raid tickets.",
                                  style: TextStyle(
                                    color: Colors.lightGreenAccent,
                                    fontWeight: FontWeight.bold,
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
          );
        },
      ),
    );
  }
}
