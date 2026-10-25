import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget storyCards(
    BuildContext context, {
      required String text,

    }) {
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;

  return Card(

    elevation: 100,
    shadowColor: const Color.fromRGBO(124, 58, 237, 0.4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(
        color: Color.fromRGBO(124, 58, 237, 0.3),
        width: 3,
      ),
    ),
    clipBehavior: Clip.antiAlias, // Clips image to rounded corners
    color: const Color.fromRGBO(255, 255, 255, 0.08),
    child: SizedBox(
      height: height * 0.2,
      width: width * 0.35,
      child: Stack(
        fit: StackFit.expand,
        children: [

          // Background Image
          Opacity(
            opacity: 0.6,
            child: Image.asset(
              "assets/images/kishore_kumar.WEBP",
              fit: BoxFit.cover,
            ),
          ),


          Container(
            color: Color.fromRGBO(0, 0, 0,0.35),
          ),


          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color.fromRGBO(124, 58, 237, 0.25),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          Padding(

            padding: const EdgeInsets.only(bottom: 2.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                text,
                style: GoogleFonts.outfit(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}