import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_connect/controller/session.dart';
import 'package:dr_connect/view/Pat/PatHomepg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      print("Step: Initiating Google Sign-In");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // User canceled sign-in
      }

      print("Step: Google user signed in: ${googleUser.email}");
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print("Step: Authenticating with Firebase");
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        print("Step: User authenticated: ${user.email}");
        // Save user data in Firestore if not already present
        final userDoc = _firestore.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          print("Step: Creating new Firestore document for user");
          await userDoc.set({
            'name': user.displayName ?? 'Anonymous',
            'email': user.email,
            'phone': '0000000000',
            'hashedPassword': '',
            // Google users don't require a password
            'profileImage':
                'https://firebasestorage.googleapis.com/v0/b/skillshare-1204d.firebasestorage.app/o/profile%2Fprofile.png?alt=media&token=bd6851ba-051c-454c-b300-290b8897a916',
            // Default image URL
          });
        }

        // Set session data using SessionManager
        await SessionManager().setSessionManager(
          user.email!,
          user.uid,
          googleName: user.displayName,
        );

        // Navigate to home page
        print("Step: Navigating to home page");

        /*Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PatHomePg(),
            ));*/

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PatHomePg(),
          ),
              (Route<dynamic> route) => false, // This removes all the previous routes
        );
      }
      return user;
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
