import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shomic_2/Components/loginIconsWidget.dart';
import 'package:shomic_2/Screens/AuthScreens/VerifyEmailScreen.dart';

import 'package:shomic_2/Services/AuthandLogServices/signInServices.dart';

class signInScreen extends StatefulWidget {
  const signInScreen({super.key});

  @override
  State<signInScreen> createState() => _signInScreenState();
}

class _signInScreenState extends State<signInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF050505), Color(0xFF1A1033), Color(0xFF0A0A0A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Shomic",
                    style: GoogleFonts.outfit(
                      color: Colors.deepPurple,
                      fontSize: 50,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                      shadows: [Shadow(color: Colors.deepPurple, blurRadius: 15)],
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Your Music. Your World",
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.deepPurple, blurRadius: 7.0)],
                    ),
                  ),
                ),
            
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
            
                      padding: EdgeInsets.all(15),
                      height: 600,
                      width: 390,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white12,
                            spreadRadius: 2.0,
                            blurRadius: 30,
                          ),
                        ],
            
                        border: Border.all(
                          color: Color.fromRGBO(255, 255, 255, 0.25),
                        ),
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Welcome Back",
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontWeight: FontWeight.w700,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Sign in to enjoying your music",
                              style: GoogleFonts.poppins(
                                color: Colors.white60,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: usernameController,
                            style: GoogleFonts.inter(color: Colors.white70),
                            decoration: InputDecoration(
                              hintText: "Username",
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.deepPurpleAccent,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            style: GoogleFonts.inter(color: Colors.white70),
                            controller: emailController,
                            decoration: InputDecoration(
            
                              hintText: "Email Address",
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: Icon(
                                Icons.email_rounded,
                                color: Colors.deepPurpleAccent,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            style: GoogleFonts.inter(color: Colors.white70),
                            controller: passwordController,
                            decoration: InputDecoration(
            
                              hintText: "Password",
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline_rounded,
                                color: Colors.deepPurpleAccent,
                              ),
                              suffixIcon: Icon(
                                Icons.remove_red_eye,
                                color: Colors.deepPurpleAccent,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
            
                          SizedBox(height: 30),
                          SizedBox(
                            width: 350,
                            child: ElevatedButton(
                              onPressed: () async {
                                await createUserWithEmailAndPassword(
                                  context,
                                  username: usernameController.text
                                      .toLowerCase()
                                      .trim(),
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );


                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent,
                                shadowColor: Color(0xFFA855F7),
                              ),
                              child: Text(
                                "Sign in",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            height: 30,
                            child: Text(
                              "or continue with",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white70,
                              ),
                            ),
                          ),
            
                          SizedBox(height: 20),
            
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
