import 'dart:async';
import 'dart:convert';

import 'package:bc4f/model/group.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/prefs.dart';
import 'package:flutter/material.dart';

class GroupProvider with ChangeNotifier {
  List<BarcodeGroup> groups = [];
  StreamSubscription subs;

  GroupProvider({bool autoload = true}) {
    if (autoload) load();
  }

  void load() {
    if (subs == null)
      subs = BarcodeService.streamGroups().listen((snap) {
        groups = snap;
        notifyListeners();
      });
  }

  Future<void> saveToLocal() async {
    final list = groups.map((b) => b.toJson()).toList();
    final jsonStr = json.encode(list);
    Prefs().instance.setString(LOCALSTORE_GROUPS, jsonStr);
  }

  Future<void> close() async {
    if (subs != null) await subs.cancel();
    subs = null;
    groups = [];
    notifyListeners();
  }
}
