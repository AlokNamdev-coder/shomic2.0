


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shomic_2/Components/LiquidGlassUi.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Welcome Back, Alok",
          style: GoogleFonts.inter(
            color: Colors.white60,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.white, blurRadius: 1)],
          ),
        ),
        actions: [
          Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
            size: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.circle_rounded,
              color: Colors.deepPurpleAccent,
              size: 40,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "What's The Vibe",
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [Shadow(color: Colors.white, blurRadius: 8)],
                        ),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        padding: EdgeInsets.only(
                          left: 32,
                          right: 32,
                          top: 12,
                          bottom: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurpleAccent),
                          borderRadius: BorderRadius.circular(20),

                          color: Color.fromRGBO(0, 0, 0, 0.3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "My Mix",
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white60,
                                shadows: [
                                  Shadow(color: Colors.white, blurRadius: 8),
                                ],
                              ),
                            ),

                            Icon(
                              Icons.navigate_next_rounded,
                              color: Colors.deepPurpleAccent,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        "Now?",
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                          shadows: [
                            Shadow(
                              color: Colors.deepPurpleAccent,
                              blurRadius: 10.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: height * 0.21,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return storyCards(context, text: "My Story");
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Align(alignment: Alignment.centerLeft,child: Text("For You",style: GoogleFonts.outfit(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white,shadows: [Shadow(color: Colors.white,blurRadius: 8)]),)),
                SizedBox(height: 5,),
                SizedBox(height: height*0.21,child: ListView.builder(scrollDirection: Axis.horizontal,itemCount: 5,itemBuilder: (context,index){return storyCards(context, text:"");})),
                SizedBox(height: 10,),
                Align(alignment: Alignment.centerLeft,child: Text("Continue Listening",style: GoogleFonts.outfit(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white,shadows: [Shadow(color: Colors.white,blurRadius: 8)]),)),
                SizedBox(height: 5,),
                SizedBox(height: height*0.21,child: ListView.builder(scrollDirection: Axis.horizontal,itemCount: 5,itemBuilder: (context,index){return storyCards(context, text:"");})),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
