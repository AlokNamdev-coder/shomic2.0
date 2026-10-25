import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:shomic_2/Components/SnackBar.dart';

Future<FilePickerResult?> filePicking(BuildContext context, {required userID}) async {
  try {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.audio,
    );
    if (result == null) {
      if (context.mounted) {
        customSnackBar(context, text: "User Cancelled File Picking");
        return null;
      }
    }

    return result;


  } catch (e) {
    if(context.mounted){
    customSnackBar(context, text: e.toString());
    return null;
  }}

  return null;
}

Future<String?> fileUploading(BuildContext context,{required FilePickerResult result,userId})async{
  try{
    final file = File(result.files.single.path!);
    final filename = (result.files.single.name);

    final ref = FirebaseStorage.instance.ref().child("uploads").child(
        userId).child("files").child("${DateTime
        .now()
        .millisecondsSinceEpoch}_$filename");

    final uploadFile = ref.putFile(file);
    await uploadFile;
    final downloadUrl = await ref.getDownloadURL();

    return downloadUrl;
  }catch(e){
    if(context.mounted){
    customSnackBar(context, text: e.toString());
  }
  }

  return null;

}
