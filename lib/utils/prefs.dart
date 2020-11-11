import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  Prefs._internal() {
    SharedPreferences.getInstance().then((prefs) => _shared = prefs);
  }

  static final Prefs _singleton = Prefs._internal();

  factory Prefs() {
    return _singleton;
  }

  SharedPreferences _shared;

  SharedPreferences get instance => _shared;
}
