import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shomic_2/Screens/PrimaryScreens/homeScreen.dart';
import 'package:shomic_2/Screens/PrimaryScreens/meel_screen.dart';
import 'package:shomic_2/Screens/PrimaryScreens/profile_screen.dart';
import 'package:shomic_2/Screens/PrimaryScreens/search_Screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int index = 0;

  final List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
    MeelScreen(),
    ProfileScreen(userId: FirebaseAuth.instance.currentUser!.uid,),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            screens[index],
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.08),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: Color.fromRGBO(255, 255, 255,0.15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(onTap:(){setState(() {
                          index=0;
                        });},child: Icon(Icons.home_outlined, color: Colors.white)),
                        InkWell(onTap: (){setState(() {
                          index=1;
                        });},child: Icon(Icons.search_outlined, color: Colors.white)),
                        InkWell(onTap:(){setState(() {
                          index=2;
                        });},child: Icon(Icons.library_music_outlined, color: Colors.white)),
                        InkWell(onTap: (){setState(() {
                          index=3;
                        });},child: Icon(Icons.person_outline, color: Colors.white)),
                      ],
                    ),
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
