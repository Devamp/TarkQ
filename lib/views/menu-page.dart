import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login-page.dart';
import 'menu-routes/account-settings.dart';
import 'menu-routes/release-notes-settings.dart';
import 'navbar-views/profile-page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  Widget buildSettingModule(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Widget targetPage,
  ) {
    TextStyle dialogTextStyle(BuildContext context, {Color? color}) =>
        TextStyle(
          fontSize: 16,
          color: color ?? Colors.black,
          fontWeight: FontWeight.bold,
        );

    void showLogoutDialog() {
      showCupertinoDialog(
        context: context,
        builder:
            (_) => CupertinoAlertDialog(
              title: Text('Are you sure?', style: dialogTextStyle(context)),
              content: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'You will be logged out.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text('Yes', style: dialogTextStyle(context)),
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
                    style: dialogTextStyle(context, color: Colors.redAccent),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
      );
    }

    return GestureDetector(
      onTap:
          () =>
              title == 'Logout'
                  ? showLogoutDialog()
                  : Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => targetPage),
                  ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white.withAlpha(75), width: 1.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 10.0, top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 35,
                color:
                    title == "Logout"
                        ? Colors.redAccent
                        : Colors.lightGreenAccent,
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color:
                            title == "Logout"
                                ? Colors.redAccent
                                : Colors.lightGreenAccent,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Menu'),
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            buildSettingModule(
              context,
              Icons.account_box,
              'Account',
              'Manage your account settings, password, and account deletion',
              const AccountSettings(),
            ),
            buildSettingModule(
              context,
              Icons.info_outline_rounded,
              'Release Notes',
              'View latest release notes on TarkQ',
              const ReleaseNotes(),
            ),
            buildSettingModule(
              context,
              Icons.logout,
              'Logout',
              'Log out from your account',
              const ReleaseNotes(),
            ),
            SizedBox(height: 30),
            Text(
              'Version 1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
