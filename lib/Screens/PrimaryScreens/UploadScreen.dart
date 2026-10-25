import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shomic_2/Components/UploadWidget.dart';
import 'package:shomic_2/Services/Media/MediaServices.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Text(
              "Upload Meel",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 2),
            Icon(Icons.star_border, color: Colors.deepPurpleAccent, size: 28),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: height * 0.3,
                    width: height * 0.8,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 0.09),
                        ),
                      ),
                      color: Color.fromRGBO(20, 16, 31, 0.80),
                      child: Center(
                        child: Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: () {
                                  print("Clicked");
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: DottedBorder(
                                    options: RoundedRectDottedBorderOptions(
                                      radius: Radius.circular(20),
                                      color: Colors.deepPurpleAccent,
                                      dashPattern: [10, 5],
                                    ),
                                    child: Container(
                                      // margin: EdgeInsets.all(15),
                                      height: height * 0.2,
                                      width: width * 0.35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color.fromRGBO(20, 16, 31, 1),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_outlined,
                                              color: Colors.deepPurpleAccent,
                                              size: 30,
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              "Add Music File",
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              "MP3,AAC up to 60s",
                                              style: GoogleFonts.inter(
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                uploadSupporters(
                                  Icons.music_note_outlined,
                                  "Music",
                                  "add your track",
                                  height * 0.07,
                                  width * 0.4,
                                ),
                                uploadSupporters(
                                  Icons.waves,
                                  "Keep it Short",
                                  "Up to 60s",
                                  height * 0.07,
                                  width * 0.4,
                                ),
                                uploadSupporters(
                                  Icons.movie_creation_outlined,
                                  "Be Creative",
                                  "show your vibe\ninspire other",
                                  height * 0.074,
                                  width * 0.4,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    print("Button pressed");
                    try {
                      await MediaService().getAudioFiles();
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text("Press me"),
                ),
                // SizedBox(height: 10),
                // Text(
                //   "Details",
                //   style: GoogleFonts.outfit(
                //     color: Colors.white,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 22,
                //   ),
                // ),
                //SizedBox(height: 10),
                // Container(
                //   padding: EdgeInsets.all(9),
                //   height: height * 0.162,
                //   width: height * 0.8,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(20),
                //     border: Border.all(
                //       color: Color.fromRGBO(255, 255, 255, 0.09),
                //     ),
                //     color: Color.fromRGBO(20, 16, 31, 0.8),
                //   ),
                //   child: TextField(
                //     style: TextStyle(color: Colors.white70),
                //     maxLines: 6,
                //     minLines: 6,
                //     controller: descriptionController,
                //     decoration: InputDecoration(
                //       suffixIcon: Align(
                //         alignment: Alignment.bottomRight,
                //         child: Icon(
                //           Icons.sentiment_satisfied_alt_outlined,
                //           color: Colors.white70,
                //         ),
                //       ),
                //       border: InputBorder.none,
                //       focusedBorder: InputBorder.none,
                //       enabledBorder: InputBorder.none,
                //       hintText: "Write a catchy description",
                //       hintStyle: TextStyle(
                //         color: Colors.white70,
                //         fontWeight: FontWeight.bold,
                //         fontSize: 12,
                //       ),
                //     ),
                //   ),
                // ),
                //SizedBox(height:height*0.03),
                // Container(
                //   height: height * 0.1,
                //   width: height * 0.8,
                //   decoration: BoxDecoration(
                //     color: Color.fromRGBO(20, 16, 31, 0.8),
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       uploadSupporters(
                //         Icons.image_search_outlined,
                //         "Cover",
                //         "select a thumbnail",
                //         height * 0.06,
                //         width * 0.5,
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Icon(
                //           Icons.navigate_next_outlined,
                //           color: Colors.white70,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                //SizedBox(height:height*0.08),
                // Padding(
                //   padding: EdgeInsets.all(10),
                //   child: SizedBox(
                //     height: height * 0.06,
                //     width: height * 0.7,
                //     child: ElevatedButton(
                //       onPressed: () {},
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.deepPurpleAccent,
                //       ),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Icon(Icons.upload_outlined, color: Colors.white,size: 28,),
                //           SizedBox(width: 2),
                //           Text(
                //             "Upload",
                //             style: GoogleFonts.outfit(
                //               color: Colors.white,
                //               fontWeight: FontWeight.bold,
                //               fontSize: 16
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
