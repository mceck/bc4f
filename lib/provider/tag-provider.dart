import 'dart:async';

import 'package:bc4f/model/tag.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:flutter/material.dart';

class TagProvider with ChangeNotifier {
  List<Tag> tags = [];
  StreamSubscription subs;

  TagProvider({bool autoload = true}) {
    if (autoload) load();
  }

  void load() {
    if (subs == null)
      subs = BarcodeService.streamTags().listen((snap) {
        tags = snap;
        notifyListeners();
      });
  }

  Future<void> close() async {
    if (subs != null) await subs.cancel();
    subs = null;
    tags = [];
    notifyListeners();
  }
}
