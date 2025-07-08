import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import '../../globals.dart';
import '../login-page.dart';
import '../navbar-views/profile-page.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  void _showPasswordInputDialog(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final email = userServices.getUserEmail();

    void _showLoadingDialog(BuildContext context, String message) {
      showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder:
            (_) => CupertinoAlertDialog(
              content: Column(
                children: [
                  SizedBox(height: 10),
                  CupertinoActivityIndicator(radius: 12),
                  SizedBox(height: 15),
                  Text(message, style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
      );
    }

    showCupertinoDialog(
      context: context,
      builder:
          (ctx) => CupertinoAlertDialog(
            title: Text("Confirm Password"),
            content: Column(
              children: [
                SizedBox(height: 5),
                Text(
                  'Please enter your password again to confirm your decision',
                ),
                SizedBox(height: 10),
                CupertinoTextField(
                  controller: passwordController,
                  placeholder: 'Enter your password',
                  placeholderStyle: TextStyle(fontSize: 12, color: Colors.grey),
                  obscureText: true,
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text(
                  "Confirm Delete",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  if (passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Password entry is required!',
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  Navigator.of(ctx).pop();

                  _showLoadingDialog(context, "Deleting account...");

                  try {
                    await userServices.reauthenticateAndDelete(
                      email,
                      passwordController.text,
                    );

                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(builder: (_) => Login()),
                    );
                  } catch (e) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.redAccent),
                          "Failed to delete account, please check your password",
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder:
          (ctx) => CupertinoAlertDialog(
            title: Text(
              "Delete Account",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              "Are you sure you want to delete your account? This action is permanent.",
            ),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(ctx).pop(); // Close confirmation dialog
                  _showPasswordInputDialog(context); // Show password dialog
                },
                child: Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String username = userServices.getUsername();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Account Settings'),
        titleTextStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(isTablet(context) ? 20 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfilePicture(
              name: username.toUpperCase(),
              radius: isTablet(context) ? 70 : 40,
              fontsize: isTablet(context) ? 44 : 30,
            ),
            SizedBox(height: 12),
            Text(
              username,
              style: TextStyle(
                fontSize: isTablet(context) ? 28 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            Divider(color: Colors.white24),
            ListTile(
              leading: Icon(Icons.delete_outline, color: Colors.redAccent),
              title: Text(
                "Delete Account",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => _showDeleteConfirmation(context),
            ),
            Divider(color: Colors.white24),
          ],
        ),
      ),
    );
  }
}
