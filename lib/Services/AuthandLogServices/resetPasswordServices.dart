import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shomic_2/Components/SnackBar.dart';

Future<void>resetPassword(BuildContext context,{required String email})async{
  try{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    if(context.mounted){
      customSnackBar(context, text: "We have Successfully Send The Password Reset Link ");
    }

  }catch(e){
    if(context.mounted){
    customSnackBar(context, text:"Something Went Wrong While Resetting Password");
  }}
}