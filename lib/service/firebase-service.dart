import 'package:bc4f/utils/app-status.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/utils/prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static Future<void> loginWithEmailAndPassword(String email, String password) {
    return _login(() => FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password));
  }

  static Future<void> signupWithEmailAndPassword(
      String email, String password) {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> logout() async {
    final isOffline = AppStatus().offlineMode;
    try {
      await AppStatus().resetProviders();
      await AppStatus().authStorage?.deleteAll();
      // await Prefs().instance?.remove(KEYSTORE_EMAIL);
    } catch (e) {
      log.warning('Error logout');
      log.severe(e);
    }
    AppStatus().loggedUser = null;
    if (isOffline && AppStatus().refreshAuthState != null)
      AppStatus().refreshAuthState();
    else
      await FirebaseAuth.instance.signOut();
  }

  static Future<void> _login(
      Future<UserCredential> Function() loginFunc) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        AppStatus().loggedUser = currentUser;
        log.info('already logged in $currentUser');
      } else {
        final login = await loginFunc();
        AppStatus().loggedUser = login?.user;
        log.info('logged in ${login?.user}');
      }
    } catch (e) {
      log.warning('login error $e');
      AppStatus().loggedUser = null;
      throw e;
    }
  }
}
