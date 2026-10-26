
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget uploadSupporters(IconData icon,String main,String other,double height,double width){
  return Container(

    height:height ,
    width: width,
    padding: EdgeInsets.all(8),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 6),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(20, 16, 31,1)
            ),
            child: Icon(icon,color:Colors.deepPurpleAccent,),

          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(main,style: GoogleFonts.inter(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 12),),
              Text(other,style: GoogleFonts.inter(fontWeight: FontWeight.bold,color: Colors.white70,fontSize: 10),),
            ],
          ),


        ],
      ),
    ),
  );

}