import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tark_q/views/filter-page.dart';
import 'package:tark_q/views/menu-page.dart';
import 'package:tark_q/views/navbar-views/lfr-page.dart';
import 'package:tark_q/views/navbar-views/profile-page.dart';
import 'package:tark_q/views/raid-form.dart';
import '../globals.dart';
import '../views/navbar-views/main-page.dart';

class NavBar extends StatefulWidget {
  final int initialIndex;

  const NavBar({super.key, this.initialIndex = 0});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late int _selectedIndex;
  Map<String, String> filters = {};
  bool isFilterApplied = false;
  final List<Text> _titles = [
    Text(''),
    Text('Looking for Raid'),
    Text('Profile'),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await userServices.loadUserOnLogin();
    });
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final bool isOnHome = _selectedIndex == 1;
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

    final List<Widget> pages = [MainPage(), LFR(filters), Profile()];

    TextStyle _titleStyle(BuildContext context) =>
        TextStyle(fontWeight: FontWeight.bold, fontSize: 22);

    TextStyle _dialogTextStyle(BuildContext context, {Color? color}) =>
        TextStyle(
          fontSize: 16,
          color: color ?? Colors.black,
          fontWeight: FontWeight.bold,
        );

    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar:
            _selectedIndex == 2
                ? AppBar(
                  automaticallyImplyLeading: false,
                  title: _titles[_selectedIndex],
                  titleTextStyle: _titleStyle(context),
                  backgroundColor: Colors.transparent,
                  leading:
                      isOnHome
                          ? IconButton(
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
                            color:
                                isFilterApplied
                                    ? Colors.lightGreenAccent
                                    : Colors.white,
                            icon: Icon(Icons.tune, size: 24),
                          )
                          : SizedBox(),

                  actions: [
                    if (isOnHome)
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          size: isTablet(context) ? 36 : 28,
                        ),
                        color: Colors.lightGreenAccent,
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => RaidForm()),
                            ).then((_) => setState(() {})),
                      ),
                    if (_selectedIndex == 2)
                      IconButton(
                        icon: Icon(Icons.menu, size: 25),
                        color: Colors.white,
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => MenuPage()),
                            ),
                      ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1.0),
                    child: Container(
                      height: 1.0,
                      color:
                          isOnHome
                              ? Colors.grey.withAlpha(75)
                              : Colors.transparent,
                    ),
                  ),
                )
                : null,
        body: pages[_selectedIndex],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.lightGreenAccent,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: _dialogTextStyle(context),
            unselectedLabelStyle: _dialogTextStyle(context),
            enableFeedback: false,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 22),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.public, size: 22),
                label: 'LFR',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 22),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
