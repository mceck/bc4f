import 'dart:async';
import 'dart:convert';

import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/prefs.dart';
import 'package:flutter/material.dart';

class BarcodeProvider with ChangeNotifier {
  List<Barcode> barcodes = [];
  StreamSubscription subs;

  BarcodeProvider({bool autoload = true}) {
    if (autoload) load();
  }

  void load() {
    if (subs == null)
      subs = BarcodeService.streamBarcodes().listen((snap) {
        barcodes = snap;
        notifyListeners();
      });
  }

  Future<void> saveToLocal() async {
    final list = barcodes.map((b) => b.toJson()).toList();
    final jsonStr = json.encode(list);
    Prefs().instance.setString(LOCALSTORE_BARCODES, jsonStr);
  }

  Future<void> close() async {
    if (subs != null) await subs.cancel();
    subs = null;
    barcodes = [];
    notifyListeners();
  }
}
