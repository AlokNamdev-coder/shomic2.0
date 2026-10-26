import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget meelDisplayedOnProfile(BuildContext context ,{required String text}){
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;
  return Card(
    color: Color.fromRGBO(255, 255, 255,0.08),
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Color.fromRGBO(255, 255, 255,0.15),),
      borderRadius: BorderRadius.circular(20)
    ),
    clipBehavior: Clip.antiAlias,
    child: SizedBox(
      height:height*0.18,
      width:width*0.30,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: height*0.14,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 3,horizontal: 8),
              clipBehavior: Clip.antiAlias,
             width: width*0.30,
              height: height*0.04,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.15),
              ),
              child: Center(child: Text("$text    ▶︎",style: GoogleFonts.inter(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.white),overflow: TextOverflow.ellipsis,maxLines: 1,)),
            ),
          )


        ],
      ),
    ),


  );
}