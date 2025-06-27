import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tark_q/views/navbar-views/profile-page.dart';
import 'package:tark_q/views/signup-page.dart';
import 'package:tark_q/views/welcome-intro.dart';
import 'dart:async';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  Timer? timer;
  bool verificationStatus = false;
  bool initialLoad = true;
  bool emailResent = false;

  @override
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

    timer = Timer.periodic(Duration(seconds: 3), (Timer t) async {
      final status = await userServices.verifyUserVerification();

      if (!mounted) return;

      if (status != null) {
        setState(() {
          verificationStatus = status;
          initialLoad = false;
        });

        if (status) {
          timer?.cancel();
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => WelcomeIntro()));
        }
      }
    });
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
                'Please check your inbox/spam folder for the verification link. Once verified, you will be automatically redirected.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(height: 30),
              LoadingAnimationWidget.fourRotatingDots(
                color: Colors.lightGreenAccent,
                size: 50,
              ),
              SizedBox(height: 30),
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
                  backgroundColor: Colors.lightGreenAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
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
