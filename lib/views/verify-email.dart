import 'package:flutter/material.dart';
import 'package:tark_q/components/nav-bar.dart';
import 'package:tark_q/views/navbar-views/home-page.dart';
import 'package:tark_q/views/navbar-views/profile-page.dart';
import 'package:tark_q/views/signup-page.dart';
import 'dart:math';

import 'package:tark_q/views/welcome-intro.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  bool verificationStatus = false;
  bool initialLoad = true;
  bool emailResent = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _shakeAnimation = Tween<double>(
      begin: -4,
      end: 4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () async {
            await userServices.deleteUserAccount();

            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => Signup()));
          },
          icon: Icon(Icons.chevron_left, size: 34, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: child,
                  );
                },
                child: Icon(
                  Icons.email_outlined,
                  color: Colors.lightGreenAccent,
                  size: 100,
                ),
              ),
              const Text(
                'Email Verification',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                textAlign: TextAlign.center,
                'Please check your inbox for the verification link. Once verified, click the button below!',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final status = await userServices.verifyUserVerification();
                  setState(() {
                    verificationStatus = status!;
                    initialLoad = false;
                  });
                  if (status!) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => WelcomeIntro()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: IntrinsicWidth(
                  child: Row(
                    children: [
                      Icon(
                        Icons.refresh_outlined,
                        color: Colors.black,
                        size: 22,
                      ),
                      SizedBox(width: 5),
                      const Text(
                        'Verify',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              const Text(
                textAlign: TextAlign.center,
                'Make sure to check the SPAM folder!',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(height: 8),
              !verificationStatus && !initialLoad
                  ? Text(
                    'Email is still unverified, please try again.',
                    style: TextStyle(color: Colors.redAccent, fontSize: 16),
                  )
                  : SizedBox(),
              Spacer(),
              emailResent
                  ? const Text(
                    'Email sent!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreenAccent,
                    ),
                  )
                  : SizedBox(),
              ElevatedButton(
                onPressed: () async {
                  await userServices.sendEmailVerificationLink();
                  setState(() {
                    emailResent = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: IntrinsicWidth(
                  child: Row(
                    children: [
                      Icon(Icons.link, color: Colors.black, size: 22),
                      SizedBox(width: 5),
                      const Text(
                        'Resend Link',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
