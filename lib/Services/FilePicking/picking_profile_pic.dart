import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:shomic_2/Components/SnackBar.dart';

Future<String?> profilePicking(BuildContext context, String userId) async {
  try {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (result == null) {
      if (context.mounted) {
        customSnackBar(context, text: "failed to Select Profile.Try Again");
      }
      return null;

    }

    final file = File(result.files.single.path!);
    final filename = (result.files.single.name);

    final ref = FirebaseStorage.instance
        .ref()
        .child("uploads")
        .child(userId)
        .child("profile_pic")
        .child("${DateTime.now().millisecondsSinceEpoch}_$filename");

    final uploadFile = ref.putFile(file);
    await uploadFile;
    final downloadUrl = await ref.getDownloadURL();

    return downloadUrl;
  } catch (e) {
    if (context.mounted) {
      customSnackBar(context, text: "Error While Selecting Profile.Try Again");

    }
    return null;
  }
}
