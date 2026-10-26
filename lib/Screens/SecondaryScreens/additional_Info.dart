import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shomic_2/Components/SnackBar.dart';
import 'package:shomic_2/Screens/SecondaryScreens/date_time_screen.dart';

class AdditionalInfo extends StatefulWidget {
  final String email;
  final String username;
  const AdditionalInfo({super.key,required this.username,required this.email});

  @override
  State<AdditionalInfo> createState() => _AdditionalInfoState();
}

class _AdditionalInfoState extends State<AdditionalInfo> {
  TextEditingController fullName = TextEditingController();
  String phoneNumber = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Shomic.",
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 50,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              style: TextStyle(color: Colors.white),
              controller: fullName,
              decoration: InputDecoration(
                hintText: "Full Name",
                hintStyle: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Icon(Icons.person, color: Colors.deepPurpleAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 20),
            IntlPhoneField(
              validator: (phone) {

                if (phone == null || phone.number.length < 6) {
                  return "Enter a valid phone number";
                }

                return null;
              },
              style: TextStyle(color: Colors.white),
              initialCountryCode: "IN",

              onChanged: (phone) {
                phoneNumber = phone.completeNumber;
              },
              decoration: InputDecoration(
                hintText: "Phone Number",
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
              onPressed: () {
                if(fullName.text=="" && phoneNumber==""){
                  customSnackBar(context, text:"Please Enter All Details");
                }else if (fullName.text=="" || phoneNumber==""){
                  customSnackBar(context, text:"Please Enter Details");
                }else{
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DateTimeScreen(email: widget.email,username: widget.username,fullname: fullName.text,phoneNumber:phoneNumber,)));
                }
              },
              child: Text(
                "Next",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
