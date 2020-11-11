import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/service/firebase-service.dart';
import 'package:bc4f/utils/logger.dart';

class Auth with ChangeNotifier {
  User user;
  AdditionalUserInfo additionalUserInfo;

  bool get isLogged => user != null;

  void setUser(User u) {
    user = u;
  }

  Future<void> _login(Future<UserCredential> Function() loginFunc) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        user = currentUser;
        log.info('already logged in $user');
        additionalUserInfo = null;
      } else {
        final login = await loginFunc();
        user = login?.user;
        log.info('logged in $user');
        additionalUserInfo = login?.additionalUserInfo;
      }
    } catch (e) {
      log.warning('login error $e');
      user = null;
      additionalUserInfo = null;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    await _login(
        () => FirebaseService.loginWithEmailAndPassword(email, password));
    notifyListeners();
  }

  Future<void> signupWithEmailAndPassword(String email, String password) async {
    await FirebaseService.signupWithEmailAndPassword(email, password);
    notifyListeners();
  }

  Future<void> logout() async {
    await FirebaseService.logout();
    user = null;
    additionalUserInfo = null;
    notifyListeners();
  }
}
