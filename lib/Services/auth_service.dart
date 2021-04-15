import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _fireStore = FirebaseFirestore.instance;

  static Future<bool> signUp(String name, String email, String pw) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: pw);

      User signedInUser = authResult.user;

      if (signedInUser != null) {
        _fireStore.collection('users').doc(signedInUser.uid).set(
          {
            'name': name,
            'email': email,
            'profilePicture': '',
            'coverImage': '',
            'bio': ''
          },
        );
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> signIn(String email, String pw) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pw);
      return true;
    } catch (e) {
      print(e);
      print('oops');
      return false;
    }
  }

  static void logout() {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
