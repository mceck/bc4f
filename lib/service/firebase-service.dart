import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<UserCredential> signupWithEmailAndPassword(
      String email, String password) {
    // TODO implement
    throw UnimplementedError();
  }

  static Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }
}
