import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ScaffoldFeatureController customSnackBar(BuildContext context, {required String text}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Color.fromRGBO(0, 0, 0,0.2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(horizontal: 20),
      content: Text(
        text,
        style: GoogleFonts.outfit(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
