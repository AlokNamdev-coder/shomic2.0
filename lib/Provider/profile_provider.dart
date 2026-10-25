

import 'package:flutter/material.dart';
import 'package:shomic_2/Components/SnackBar.dart';
import 'package:shomic_2/Services/User/user.dart';

import '../Models/user_models.dart';

class ProfileProvider extends ChangeNotifier {

  Future<UserM?>?user;


  void getUsers(BuildContext context,String userId){
    try{
      user = fetchUser(userId);
      notifyListeners();
    }catch(e){
      customSnackBar(context, text:e.toString());
    }
  }

  // void createUsers(BuildContext context,User user){
  //   try{
  //     createUser(user);
  //   }catch(e){
  //     customSnackBar(context, text:"Problem Occured While Creating User");
  //   }
  // }


}