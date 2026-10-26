import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shomic_2/Screens/PrimaryScreens/homeScreen.dart';

Future<void>loginWithEmailAndPassword(BuildContext context,{required email,required password})async{
  try{
    final userCredentials = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    print(userCredentials);
    if(context.mounted){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
    }
  }catch(e){
    if(context.mounted){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

}