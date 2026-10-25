import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shomic_2/Screens/SecondaryScreens/bio_screen.dart';
import 'package:shomic_2/Screens/SecondaryScreens/gender_screen.dart';
import 'package:shomic_2/Services/Date_time/date_time.dart';

class DateTimeScreen extends StatefulWidget {
  final String email;
  final String username;
  final String fullname;
  final String phoneNumber;
  const DateTimeScreen({
    super.key,
    required this.username,
    required this.fullname,
    required this.phoneNumber,
    required this.email,
  });

  @override
  State<DateTimeScreen> createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {
  TextEditingController dobController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsetsGeometry.all(8),
        child: Center(
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
                onTap: () {
                  selectDate(context, dobController);
                },
                controller: dobController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.deepPurpleAccent,
                  ),
                  hintText: "DD/MM/YYYY",
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => GenderScreen(
                            email: widget.email,
                            phoneNumber: widget.phoneNumber,
                            fullname: widget.fullname,
                            dateTime: dobController.text,
                            username: widget.username,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Skip",
                      style: GoogleFonts.inter(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => GenderScreen(
                          email: widget.email,
                          phoneNumber: widget.phoneNumber,
                          fullname: widget.fullname,
                          dateTime: dobController.text,
                          username: widget.username,)),
                      );
                    },
                    child: Text(
                      "Next",
                      style: GoogleFonts.inter(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
