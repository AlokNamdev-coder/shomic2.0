import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

Widget loginIconsWidget(BuildContext context,double height,double width){
  return Container(
    margin: EdgeInsets.all(5),
    height: height,
    width: width,
    decoration: BoxDecoration(
      color:Color.fromRGBO(0, 0, 0,0.2),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Color.fromRGBO(255, 255, 255,0.2)
      )
    ),
    child:Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Image.asset(
          'assets/images/icons8-google-40.png',
          height: 24,
          width: 24,
        ),
        SizedBox(width: 20,),
        Text("Google",style: GoogleFonts.inter(color: Colors.white70,fontWeight: FontWeight.bold),)
      ],
    ),
  );
}