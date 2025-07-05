import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tark_q/views/filter-page.dart';
import 'package:tark_q/views/login-page.dart';
import 'package:tark_q/views/navbar-views/home-page.dart';
import 'package:tark_q/views/navbar-views/profile-page.dart';
import 'package:tark_q/views/raid-form.dart';
import '../globals.dart';

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
  final List<Text> _titles = [Text('Looking for Raid'), Text('Profile')];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  TextStyle _titleStyle(BuildContext context) => TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: isTablet(context) ? 28 : 22,
  );

  TextStyle _dialogTextStyle(BuildContext context, {Color? color}) => TextStyle(
    fontSize: isTablet(context) ? 22 : 16,
    color: color ?? Colors.black,
    fontWeight: FontWeight.bold,
  );

  void _showLogoutDialog() {
    showCupertinoDialog(
      context: context,
      builder:
          (_) => CupertinoAlertDialog(
            title: Text('Are you sure?', style: _dialogTextStyle(context)),
            content: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'You will be logged out.',
                style: TextStyle(fontSize: isTablet(context) ? 20 : 14),
              ),
            ),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Yes', style: _dialogTextStyle(context)),
                onPressed: () {
                  userServices.signOutUser();
                  Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(builder: (_) => Login()),
                  );
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  'No',
                  style: _dialogTextStyle(context, color: Colors.redAccent),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isOnHome = _selectedIndex == 0;
    const defaultFilters = {
      'map': 'Any',
      'goal': 'Any',
      'partySize': 'Any',
      'contactMethod': 'Any',
      'pmcLevel': 'Any',
      'gameMode': 'Any',
      'skillRating': 'Any',
    };

    final List<Widget> pages = [Home(filters), Profile()];

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: _titles[_selectedIndex],
          titleTextStyle: _titleStyle(context),
          backgroundColor: Colors.black,
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
                icon: Icon(Icons.add, size: isTablet(context) ? 36 : 28),
                color: Colors.lightGreenAccent,
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RaidForm()),
                    ),
              ),
            if (!isOnHome)
              IconButton(
                icon: Icon(Icons.logout, size: isTablet(context) ? 36 : 24),
                color: Colors.redAccent,
                onPressed: _showLogoutDialog,
              ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              height: 1.0,
              color: isOnHome ? Colors.grey.withAlpha(75) : Colors.transparent,
            ),
          ),
        ),
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.lightGreenAccent,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: _dialogTextStyle(context),
          unselectedLabelStyle: _dialogTextStyle(context),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.public, size: isTablet(context) ? 28 : 22),
              label: 'LFR',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: isTablet(context) ? 28 : 22),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
