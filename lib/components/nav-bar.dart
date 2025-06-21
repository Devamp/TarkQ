import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [Home(), const Profile()];
  final List<Text> _pagesTitles = [Text('Looking for Raid'), Text('Profile')];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: 100,
          title: _pagesTitles[_selectedIndex],
          actions: [
            if (_selectedIndex == 0)
              IconButton(
                color: Colors.lightGreenAccent,
                icon: Icon(Icons.add, size: isTablet(context) ? 36 : 30),
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => RaidForm()));
                },
              ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color:
                  _selectedIndex == 0
                      ? Colors.grey.withAlpha(75)
                      : Colors.transparent,
              height: 1.0,
            ),
          ),
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTablet(context) ? 28 : 22,
          ),
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.lightGreenAccent,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTablet(context) ? 28 : 18,
          ),
          unselectedItemColor: Colors.grey,
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTablet(context) ? 28 : 18,
          ),
          backgroundColor: Colors.transparent,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.public, size: isTablet(context) ? 28 : 22),
              label: 'LFR',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: isTablet(context) ? 28 : 22),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
