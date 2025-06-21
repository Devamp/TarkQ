import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tark_q/services/user-services.dart';
import 'package:tark_q/views/login-page.dart';
import 'package:tark_q/views/verify-email.dart';
import '../errors.dart';
import '../globals.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool isLoading = false;
  bool didErrorOccur = false;
  String errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create an account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.lightGreenAccent,
                        decoration: TextDecoration.none,
                        fontSize: isTablet(context) ? 75 : 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'You\'re just a few taps away from finding your next tarkov squad.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: isTablet(context) ? 22 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      cursorColor: Colors.white,
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        hintText: "Username",
                        hintStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Username cannot be empty.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      cursorColor: Colors.white,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        hintText: "Email",
                        hintStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email cannot be empty.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password field
                    TextFormField(
                      cursorColor: Colors.white,
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        hintText: "Password",
                        hintStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password cannot be empty.';
                        }
                        return null;
                      },
                    ),
                    didErrorOccur
                        ? Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            errorMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        )
                        : const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            setState(() {
                              isLoading = true;
                            });

                            final UserCredential user = await UserServices
                                .instance
                                .signUpUser(
                                  _usernameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                );

                            if (user.user?.uid != null) {
                              // Send verification email
                              await user.user?.sendEmailVerification();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => VerifyEmail(),
                                ),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              errorMessage =
                                  getErrorMessageFromCode(e.code, e)!;
                              didErrorOccur = true;
                              isLoading = false;
                            });
                          } catch (exception) {
                            setState(() {
                              isLoading = false;
                            });
                            print(exception);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreenAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child:
                          isLoading
                              ? IntrinsicWidth(
                                child: Row(
                                  children: [
                                    LoadingAnimationWidget.inkDrop(
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              )
                              : IntrinsicWidth(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.handshake,
                                      color: Colors.black,
                                      size: isTablet(context) ? 30 : 25,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Register',
                                      style: TextStyle(
                                        fontSize: isTablet(context) ? 24 : 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap:
                          () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Login()),
                            ),
                          },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already a member? ',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                fontSize: isTablet(context) ? 24 : 15,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: isTablet(context) ? 24 : 15,
                                color: Colors.lightGreenAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 40, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
