import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tark_q/components/raid-ticket.dart';
import 'package:tark_q/services/user-services.dart';
import 'package:tark_q/views/raid-form.dart';
import '../../globals.dart';
import '../filter-page.dart';

class LFR extends StatefulWidget {
  final Map<String, String> filters;

  const LFR(this.filters, {super.key});

  @override
  State<LFR> createState() => _LFRState();
}

class _LFRState extends State<LFR> {
  final UserServices userServices = UserServices.instance;
  Map<String, String> filters = {};
  bool isFilterApplied = false;

  Future<List<Map<String, dynamic>>> _loadRaidTickets() async {
    final rawList = await userServices.getDisplayRaidTickets(
      userServices.getUserEmail(),
      filters,
    );

    // Ensure type safety by casting each item
    return rawList.map((e) => e).toList();
  }

  @override
  Widget build(BuildContext context) {
    const defaultFilters = {
      'map': 'Any',
      'goal': 'Any',
      'partySize': 'Any',
      'contactMethod': 'Any',
      'pmcLevel': 'Any',
      'gameMode': 'Any',
      'skillRating': 'Any',
      'region': 'Any',
    };

    return Container(
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
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.receipt_long,
                          color: Colors.lightGreenAccent,
                          size: 35,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Raids',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.lightGreenAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isFilterApplied
                                    ? Colors.redAccent
                                    : Colors.amberAccent,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              final userFilters = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => FilterPage()),
                              );
                              if (userFilters != null &&
                                  userFilters is Map<String, String>) {
                                setState(() {
                                  filters = userFilters;
                                  isFilterApplied =
                                      !mapEquals(userFilters, defaultFilters);
                                });
                              }
                            },
                            icon: Icon(
                              Icons.tune,
                              size: 20,
                              color: Colors.black87,
                            ),
                            padding: EdgeInsets.zero,
                            splashRadius: 22,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.lightGreenAccent,
                          ),
                          child: IconButton(
                            onPressed:
                                () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RaidForm(),
                                    ),
                                  ),
                                },
                            icon: Icon(
                              Icons.add,
                              size: 20,
                              color: Colors.black,
                            ),
                            padding: EdgeInsets.zero,
                            splashRadius: 22,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Browse raid tickets created by other PMCs',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _loadRaidTickets(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final List<Map<String, dynamic>> allTickets =
                        snapshot.data ?? [];

                    return SingleChildScrollView(
                      child:
                          allTickets.isEmpty
                              ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child:
                                      widget.filters != {}
                                          ? Column(
                                            children: [
                                              Text(
                                                "Could not find any raid tickets",
                                                style: TextStyle(
                                                  color:
                                                      Colors.lightGreenAccent,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      isTablet(context)
                                                          ? 24
                                                          : 18,
                                                ),
                                              ),
                                              Text(
                                                "Try clearing any filters",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize:
                                                      isTablet(context)
                                                          ? 24
                                                          : 14,
                                                ),
                                              ),
                                            ],
                                          )
                                          : Text(
                                            "Could not find any raid tickets.",
                                            style: TextStyle(
                                              color: Colors.lightGreenAccent,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  isTablet(context) ? 24 : 18,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
