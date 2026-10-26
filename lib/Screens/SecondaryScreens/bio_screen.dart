import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BioScreen extends StatefulWidget {
  final String email;
  final String username;
  final String fullname;
  final String phoneNumber;
  final String dateTime;
  final String gender;
  const BioScreen({super.key,required this.email,required this.username,required this.phoneNumber,required this.fullname,required this.dateTime,required this.gender});

  @override
  State<BioScreen> createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen> {
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsetsGeometry.all(8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Shomic",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                  fontSize: 50,
                ),
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.all(9),
                height: height * 0.162,
                width: height * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Color.fromRGBO(255, 255, 255, 0.09),
                  ),
                  color: Color.fromRGBO(20, 16, 31, 0.8),
                ),
                child: TextField(
                  style: TextStyle(color: Colors.white70),
                  maxLength: 50,
                  maxLines: 6,
                  minLines: 6,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    suffixIcon: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Icon(
                          Icons.sentiment_satisfied_alt_outlined,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: "Write a catchy description",
                    hintStyle: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(onPressed: (){}, child:Text("Skip",style: GoogleFonts.inter(color: Colors.deepPurpleAccent,fontWeight: FontWeight.bold),))
                ],
              )

            ],
          ),
        ),
      ),

    );
  }
}
