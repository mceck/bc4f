import 'dart:async';
import 'dart:convert';

import 'package:bc4f/model/tag.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/prefs.dart';
import 'package:flutter/material.dart';

class TagProvider with ChangeNotifier {
  List<Tag> tags = [];
  StreamSubscription<List<Tag>>? subs;

  TagProvider({bool autoload = true}) {
    if (autoload) load();
  }

  void load() {
    subs ??= BarcodeService.streamTags().listen((snap) {
      tags = snap;
      notifyListeners();
    });
  }

  Future<void> saveToLocal() async {
    final list = tags.map((b) => b.toJson()).toList();
    final jsonStr = json.encode(list);
    await Prefs().instance?.setString(LOCALSTORE_TAGS, jsonStr);
  }

  Future<void> close() async {
    await subs?.cancel();
    subs = null;
    tags = [];
    notifyListeners();
  }
}
