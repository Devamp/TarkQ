import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tark_q/components/nav-bar.dart';
import 'package:tark_q/errors.dart';
import 'package:tark_q/views/navbar-views/profile-page.dart';
import 'package:tark_q/views/signup-page.dart';
import 'package:tark_q/views/welcome-intro.dart';
import '../globals.dart';
import '../services/user-services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _resetPasswordEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool didErrorOccur = false;
  bool isLoading = false;
  String errorMessage = '';

  @override
  void dispose() {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.lightGreenAccent,
                            decoration: TextDecoration.none,
                            fontSize: isTablet(context) ? 80 : 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Welcome Back!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: isTablet(context) ? 22 : 14,
                        fontWeight: FontWeight.bold,
                      ),
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
                          return 'Please enter your email.';
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
                          return 'Please enter your password.';
                        }
                        return null;
                      },
                    ),

                    didErrorOccur
                        ? Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            errorMessage,
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
                                .signInUser(
                                  _emailController.text,
                                  _passwordController.text,
                                );

                            if (user.user?.uid != null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => NavBar(),
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
                                      Icons.person,
                                      color: Colors.black,
                                      size: isTablet(context) ? 32 : 25,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: isTablet(context) ? 32 : 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.grey.shade800,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder:
                              (context) => Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                      20,
                                  left: 20,
                                  right: 20,
                                  top: 20,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Reset Password',
                                      style: TextStyle(
                                        color: Colors.lightGreenAccent,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      textAlign: TextAlign.center,
                                      'Enter your email associated with your account to reset your password.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    TextFormField(
                                      cursorColor: Colors.white,
                                      controller: _resetPasswordEmailController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.black,
                                        hintText: "Enter your email",
                                        hintStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            20.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            20.0,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          await userServices
                                              .sendPasswordResetEmail(
                                                _resetPasswordEmailController
                                                    .value
                                                    .text,
                                              );

                                          _resetPasswordEmailController.clear();

                                          Navigator.pop(
                                            context,
                                          ); // Close the sheet
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color:
                                                        Colors.lightGreenAccent,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    textAlign: TextAlign.center,
                                                    'Password reset email sent',
                                                    style: TextStyle(
                                                      color:
                                                          Colors
                                                              .lightGreenAccent,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        } catch (e) {
                                          print(e);
                                          Navigator.pop(
                                            context,
                                          ); // Close the sheet
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.error_outline,
                                                    color: Colors.redAccent,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 3),
                                                  Text(
                                                    textAlign: TextAlign.center,
                                                    'Something went wrong. Try again.',
                                                    style: TextStyle(
                                                      color: Colors.redAccent,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.lightGreenAccent,
                                      ),
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: isTablet(context) ? 24 : 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Forgot password? ',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                fontSize: isTablet(context) ? 20 : 15,
                                color: Colors.lightGreenAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 40, color: Colors.white),
                    GestureDetector(
                      onTap:
                          () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Signup()),
                            ),
                          },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'New here? ',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                fontSize: isTablet(context) ? 20 : 15,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: 'Sign up',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: isTablet(context) ? 20 : 15,
                                color: Colors.lightGreenAccent,
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
          ),
        ),
      ),
    );
  }
}
