import 'dart:async';
import 'dart:convert';

import 'package:bc4f/model/tag.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/prefs.dart';
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

  Future<void> saveToLocal() async {
    final list = tags.map((b) => b.toJson()).toList();
    final jsonStr = json.encode(list);
    Prefs().instance.setString(LOCALSTORE_TAGS, jsonStr);
  }

  Future<void> close() async {
    if (subs != null) await subs.cancel();
    subs = null;
    tags = [];
    notifyListeners();
  }
}
