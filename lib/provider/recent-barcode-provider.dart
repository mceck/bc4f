import 'dart:async';
import 'dart:convert';

import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/utils/prefs.dart';
import 'package:flutter/material.dart';

class RecentBarcodeProvider with ChangeNotifier {
  List<Barcode> barcodes = [];

  RecentBarcodeProvider() {
    load();
  }

  void pushRecent(Barcode barcode) {
    barcodes.removeWhere((bc) => bc.uid == barcode.uid);
    barcodes.insert(0, barcode);
    if (barcodes.length > 5) barcodes.removeLast();
    notifyListeners();
    save();
  }

  void load() {
    final jsonStr = Prefs().instance.getString(LOCALSTORE_RECENTS);
    if (jsonStr != null) {
      final List list = json.decode(jsonStr);
      barcodes = list.map((map) => Barcode.fromJson(map)).toList();
      log.info('loaded $list');
      notifyListeners();
    }
  }

  Future<void> save() async {
    final list = barcodes.map((bc) => bc.toJson()).toList();
    final jsonStr = json.encode(list);
    await Prefs().instance.setString(LOCALSTORE_RECENTS, jsonStr);
  }

  Future<void> close() async {
    await save();
    barcodes = [];
    notifyListeners();
  }
}
