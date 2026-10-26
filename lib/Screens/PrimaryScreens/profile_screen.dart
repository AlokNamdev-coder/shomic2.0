import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shomic_2/Components/meel_displayed_on_profile.dart';
import 'package:shomic_2/Provider/profile_provider.dart';
import 'package:shomic_2/Screens/PrimaryScreens/UploadScreen.dart';
import 'package:shomic_2/Services/FilePicking/PickingFile.dart';
import 'package:provider/provider.dart';

import '../../Models/user_models.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({super.key,required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();


}

class _ProfileScreenState extends State<ProfileScreen>{

  bool isMe = false;
  @override
  void initState() {

    super.initState();
    Provider.of<ProfileProvider>(context,listen: false).getUsers(context, widget.userId);
    isMe = FirebaseAuth.instance.currentUser!.uid==widget.userId?true:false;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(onTap:(){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UploadScreen()));},child: Icon(Icons.add,color: Colors.white,size: 30,)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.notifications_none_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.list_outlined, color: Colors.white, size: 30),
          ),
        ],
        backgroundColor: Colors.black,
        title: Consumer<ProfileProvider>(
          builder: (context, value, child) {
            return FutureBuilder<UserM?>(
              future: value.user,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading...");
                }

                if (snapshot.hasError) {
                  return const Text("Error");
                }

                final user = snapshot.data;

                return Text(
                  user?.username ?? "User",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                );
              },
            );
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Consumer<ProfileProvider>(
        builder:(context,value,child)=> FutureBuilder<UserM?>(
          future: value.user,
          builder: (context, snapshot) {
            if (snapshot.connectionState==ConnectionState.waiting){
              return CircularProgressIndicator();
            }

            if(snapshot.hasError){
              return Text("Error",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),);
            }

            final user = snapshot.data;
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.circle_outlined,
                            color: Colors.deepPurpleAccent,
                            size: 120,
                          ),
                          SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                user?.fullName??"UnKnown",
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize:height*0.02,
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                child: Text(
                                  softWrap: true,
                                  user?.bio??"Hello",
                                  style: GoogleFonts.inter(
                                    fontSize:height*0.01,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ClipRRect(

                        borderRadius: BorderRadius.circular(18),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                          child: Container(
                            height: height * 0.09,
                            width: width*0.95,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.08),
                              border: Border.all(
                                color: Color.fromRGBO(255, 255, 255, 0.15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.music_note_outlined,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    Text(
                                      "${user?.postsCount??0}",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Meels",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: height * 0.07,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 0.5,
                                      color: Color.fromRGBO(255, 255, 255, 0.15),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.people_alt_outlined,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    Text(
                                      "${user?.followersCount??0}",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "followers",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: height * 0.07,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 0.5,
                                      color: Color.fromRGBO(255, 255, 255, 0.15),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.person_outline,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    Text(
                                      "${user?.followingCount??0}",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "following",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: height * 0.07,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 0.5,
                                      color: Color.fromRGBO(255, 255, 255, 0.15),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.music_note_outlined,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    Text(
                                      "2.2k",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "plays",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                            ),
                            onPressed: () {},
                            child: SizedBox(
                              width:width*0.3 ,
                              child: Center(
                                child: Text(
                                  "Upload Meel",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(255, 255, 255, 0.08),
                            ),
                            onPressed: () {},
                            child: SizedBox(
                              width:width*0.3,
                              child: Center(
                                child: Text(
                                  "Edit Profile",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:6,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,      // 3 cards in each row
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                           // Adjust according to your card design
                        ),
                        itemBuilder: (context, index) {
                          return meelDisplayedOnProfile(
                            context,
                            text:"MoonLight",
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
