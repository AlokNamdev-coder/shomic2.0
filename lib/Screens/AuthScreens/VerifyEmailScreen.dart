import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shomic_2/Components/SnackBar.dart';
import 'package:shomic_2/Screens/PrimaryScreens/homeScreen.dart';
import 'package:shomic_2/Screens/SecondaryScreens/additional_Info.dart';

class verifyEmailScreen extends StatefulWidget {
  final String username;
  final String email;

  const verifyEmailScreen({super.key, required this.username,required this.email});

  @override
  State<verifyEmailScreen> createState() => _verifyEmailScreenState();
}

class _verifyEmailScreenState extends State<verifyEmailScreen> {
  bool isVerifying = true;
  bool isVerified = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> _isEmailVerified(BuildContext context) async {
    await FirebaseAuth.instance.currentUser!.reload();

    bool result = FirebaseAuth.instance.currentUser!.emailVerified;
    setState(() {
      isVerified = result;
    });

    if (result == true) {
      setState(() {
        isVerifying = false;
      });
      if (context.mounted) {
        customSnackBar(context, text: "Verification Successful");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } else {
      setState(() {
        isVerifying = false;
      });
    }
    print("The Status of Email Verification is $result");
  }

  Future<void> _resendEmailVerification(
    BuildContext context, {
    dynamic credentials,
  }) async {
    await credentials.user!.sendEmailVerification();
    setState(() {
      isVerifying = true;
    });
    if (context.mounted) {
      customSnackBar(
        context,
        text: "We have Successfully Sent The Email Verification ",
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF050505), Color(0xFF1A1033), Color(0xFF0A0A0A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ClipRRect(
            child: Container(
              height: height * 0.5,
              width: width * 0.95,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mail_lock_rounded,
                    size: height * 0.08,
                    color: Colors.deepPurpleAccent,
                  ),
                  Text(
                    "${widget.username}, Please Verify The Email",
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      shadows: [Shadow(color: Colors.white, blurRadius: 8.0)],
                    ),
                  ),
                  SizedBox(height: 30),
                  if (isVerifying)
                    CircularProgressIndicator()
                  else if (isVerified)
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: Colors.deepPurpleAccent,
                    )
                  else
                    Icon(
                      Icons.cancel_outlined,
                      color: Colors.deepPurpleAccent,
                      size: 20,
                    ),

                  SizedBox(height: 30),
                  TextButton(
                    onPressed: () async {
                      await _resendEmailVerification(context);
                    },
                    child: Text(
                      "[Resend The Verification]",
                      style: GoogleFonts.outfit(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            color: Colors.deepPurpleAccent,
                            blurRadius: 8.0,
                          ),
                        ],
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.currentUser!.reload();
                      _isEmailVerified(context);
                      if(isVerified){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)=>AdditionalInfo(username: widget.username,email:widget.email,)));
                      }
                    },
                    child: Text(
                      "[Verify]",
                      style: GoogleFonts.outfit(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            color: Colors.deepPurpleAccent,
                            blurRadius: 8.0,
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
    );
  }
}
