import 'dart:async';

import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/service/barcode-service.dart';
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
        barcodes =
            snap.docs.map((doc) => Barcode.fromJson(doc.data())).toList();
        notifyListeners();
      });
  }

  Future<void> close() async {
    if (subs != null) await subs.cancel();
    subs = null;
    barcodes = [];
    notifyListeners();
  }
}
