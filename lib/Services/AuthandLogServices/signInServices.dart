import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shomic_2/Components/SnackBar.dart';
import 'package:shomic_2/Screens/AuthScreens/VerifyEmailScreen.dart';


Future<bool> isUsernameAvailable(BuildContext context,String username) async {
  try {
    username = username.trim().toLowerCase();

    if (username.isEmpty) return false;

    final doc = await FirebaseFirestore.instance
        .collection("Usernames")
        .doc(username)
        .get();

    return !doc.exists;
  } catch (e) {
    if(context.mounted){
    customSnackBar(context, text:"UnKnown error occured while creating username");

  } return false;}
}

bool isValidUsername(String username) {
  username = username.trim();

  final regex = RegExp(r'^[a-zA-Z0-9_.]{3,20}$');

  return regex.hasMatch(username);
}

Future<void> createUserWithEmailAndPassword(
  BuildContext context, {
  required String username,
  required String email,
  required String password,
}) async {
  try {
    final userCredentials = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    print(userCredentials);

    await userCredentials.user!.sendEmailVerification();



    
    if(context.mounted){
    customSnackBar(context, text:"Please Verify The Email");
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>verifyEmailScreen(username: username,email: email)));
    }


  } catch (e) {
    if(context.mounted){
    customSnackBar(context, text: "Unknow Error While Signing In ");
    }
  }
}
