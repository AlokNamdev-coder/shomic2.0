import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shomic_2/Provider/profile_provider.dart';
import 'package:shomic_2/Screens/AuthScreens/loginScreen.dart';
// import 'package:shomic_2/Components/bottomnavigationbar.dart';
// import 'package:shomic_2/Screens/AuthScreens/loginScreen.dart';
import 'package:shomic_2/Screens/PrimaryScreens/homeScreen.dart';
import 'package:shomic_2/Screens/PrimaryScreens/profile_screen.dart';
import 'package:shomic_2/Screens/SecondaryScreens/additional_Info.dart';
import 'package:shomic_2/Screens/SecondaryScreens/bio_screen.dart';
import 'package:shomic_2/Screens/SecondaryScreens/date_time_screen.dart';
import 'package:shomic_2/Screens/SecondaryScreens/gender_screen.dart';
import 'package:shomic_2/Screens/SecondaryScreens/profile_screen.dart';
import 'package:shomic_2/Screens/SecondaryScreens/test_upload_screen.dart';
import 'package:shomic_2/Screens/SecondaryScreens/trimmable_waveform.dart';
import 'package:shomic_2/Screens/bottom_navigation_screen.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp( MyApp());
}

class MyApp extends StatelessWidget{
   MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>ProfileProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, asyncSnapshot) {
            if(asyncSnapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
            if(asyncSnapshot.hasData){
              return LoginScreen();
            }
            return ProfilePicScreen(email: "",username: "",fullname: "",phoneNumber: "",gender:"",dateTime: "",bio: "",);
          }
        ),
      
      ),
    );
  }
}