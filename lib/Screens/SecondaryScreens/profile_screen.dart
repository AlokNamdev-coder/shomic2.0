import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shomic_2/Components/SnackBar.dart';
import 'package:shomic_2/Models/user_models.dart';
import 'package:shomic_2/Services/FilePicking/picking_profile_pic.dart';
import 'package:shomic_2/Services/Location/fetch_location.dart';
import 'package:shomic_2/Services/User/user.dart';

class ProfilePicScreen extends StatefulWidget {
  final String email;
  final String username;
  final String fullname;
  final String phoneNumber;
  final String dateTime;
  final String gender;
  final String bio;
  const ProfilePicScreen({super.key,required this.email,required this.username,required this.fullname,required this.phoneNumber,required this.gender,required this.dateTime,required this.bio});

  @override
  State<ProfilePicScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfilePicScreen> {
  Map<String, String>? locations;
  String? profileUrl="";

  UserM? user;
  
  void loadLocation()async{
    try{
      locations = await getLocation();
      print(locations!["country"]);
      print(locations!["locality"]);
    }catch(e){

      customSnackBar(context, text:"failed to load location");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadLocation();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Shomic.",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                profileUrl = await profilePicking(context, "");
              },
              child: CircleAvatar(
                backgroundColor: Color.fromRGBO(255, 255, 255, 0.2),
                radius: 50,
                backgroundImage: profileUrl == null
                    ? AssetImage("assets/Icons/people.png")
                    : NetworkImage(profileUrl!),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "Choose the Profile Picture",
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 1.3,
                ),
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    user=UserM(id: "", username:widget.username, email:widget.email, passwordHash:"", fullName:widget.fullname, bio:widget.bio, phone:widget.phoneNumber, country:locations!["country"]!, city: locations!["locality"]!, birthDate:DateTime.parse(widget.dateTime), profilePictureUrl:" ", coverPictureUrl:"", gender:widget.gender, isVerified:false, isPrivate:false, followersCount:0, followingCount: 0, postsCount: 0,createdAt: DateTime.now(),updatedAt: DateTime.now());
                    await createUser(user!);
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
                  onPressed: profileUrl==""?null:()async{
                    user=UserM(id: "", username:widget.username, email:widget.email, passwordHash:"", fullName:widget.fullname, bio:widget.bio, phone:widget.phoneNumber, country:locations!["country"]!, city: locations!["locality"]!, birthDate:DateTime.parse(widget.dateTime), profilePictureUrl:profileUrl!, coverPictureUrl:"", gender:widget.gender, isVerified:false, isPrivate:false, followersCount:0, followingCount: 0, postsCount: 0,createdAt: DateTime.now(),updatedAt: DateTime.now());
                    await createUser(user!);
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
    );
  }
}
