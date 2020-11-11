import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:bc4f/utils/logger.dart';

/// Classe di utili di tipo _singleton che permette di memorizzare in maniera statica alcune informazione usate in tutto l'appliccativo.
class AppStatus {
  final navKey = GlobalKey<NavigatorState>();
  final authStorage = kIsWeb ? null : FlutterSecureStorage();
  PrintAppender consoleLog = PrintAppender(formatter: LogPrinter());

  User loggedUser;

  static final AppStatus _singleton = AppStatus._internal();

  factory AppStatus() {
    return _singleton;
  }

  AppStatus._internal();
}
