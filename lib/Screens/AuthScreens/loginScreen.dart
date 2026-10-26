import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shomic_2/Components/loginIconsWidget.dart';
import 'package:shomic_2/Screens/AuthScreens/signInScreen.dart';
import 'package:shomic_2/Screens/PrimaryScreens/homeScreen.dart';
import 'package:shomic_2/Services/AuthandLogServices/loginServices.dart';
import 'package:shomic_2/Services/AuthandLogServices/login_with_google_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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

                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),

                          child: Container(

                            margin: EdgeInsets.only(top: 10),

                            padding: EdgeInsets.all(15),
                            height:height*0.7,
                            width:width*0.95,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
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
                                    "Log in to continue enjoying your music",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white60,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextField(
                                  style: TextStyle(color: Colors.white),
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
                                SizedBox(height: 15),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Forgot Password?",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.deepPurpleAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                SizedBox(
                                  width: 350,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await loginWithEmailAndPassword(
                                        context,
                                        email: emailController.text.trim(),
                                        password: passwordController.text.trim(),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurpleAccent,
                                      shadowColor: Color(0xFFA855F7),
                                    ),
                                    child: Text(
                                      "Log in",
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

                                InkWell(
                                  onTap: ()async {
                                    final userCredential = await signInWithGoogle();

                                    if (userCredential!=null){
                                      if(context.mounted){
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
                                    }}
                                  },
                                  child: loginIconsWidget(
                                    context,
                                    height * 0.055,
                                    width * 0.84,
                                  ),
                                ),

                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "New here? ",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => signInScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Create an account",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
          ],
        ),
      ),
    );
  }
}
