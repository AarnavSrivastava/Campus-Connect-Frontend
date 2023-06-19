import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:school_networking_project/firebase/data_service.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  static var user = FirebaseAuth.instance.currentUser;

  Future<UserCredential> googleLogin() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    DataService.user = null;
    user = null;

    await FirebaseAuth.instance.signOut();
  }
}
