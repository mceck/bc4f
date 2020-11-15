import 'package:bc4f/provider/barcode-provider.dart';
import 'package:bc4f/provider/group-provider.dart';
import 'package:bc4f/provider/recent-barcode-provider.dart';
import 'package:bc4f/provider/tag-provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:provider/provider.dart';

/// Classe di utili di tipo _singleton che permette di memorizzare in maniera statica alcune informazione usate in tutto l'appliccativo.
class AppStatus {
  final navKey = GlobalKey<NavigatorState>();
  final authStorage = kIsWeb ? null : FlutterSecureStorage();
  PrintAppender consoleLog = PrintAppender(formatter: LogPrinter());

  User loggedUser;

  Future<void> resetProviders() async {
    final context = navKey?.currentState?.overlay?.context;
    await Provider.of<BarcodeProvider>(context, listen: false)?.close();
    await Provider.of<GroupProvider>(context, listen: false)?.close();
    await Provider.of<TagProvider>(context, listen: false)?.close();
    await Provider.of<RecentBarcodeProvider>(context, listen: false)?.close();
  }

  static final AppStatus _singleton = AppStatus._internal();

  factory AppStatus() {
    return _singleton;
  }

  AppStatus._internal();
}
