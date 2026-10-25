import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignIn signIn = GoogleSignIn.instance;


    await signIn.initialize();


    final GoogleSignInAccount googleUser = await signIn.authenticate();


    final GoogleSignInAuthentication googleAuth =
        googleUser.authentication;


    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );


    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    print("Google Sign-In Error: $e");
    return null;
  }
}