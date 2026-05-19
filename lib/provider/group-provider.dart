import 'dart:async';
import 'dart:convert';

import 'package:bc4f/model/group.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/prefs.dart';
import 'package:flutter/material.dart';

class GroupProvider with ChangeNotifier {
  List<BarcodeGroup> groups = [];
  StreamSubscription<List<BarcodeGroup>>? subs;

  GroupProvider({bool autoload = true}) {
    if (autoload) load();
  }

  void load() {
    subs ??= BarcodeService.streamGroups().listen((snap) {
      groups = snap;
      notifyListeners();
    });
  }

  Future<void> saveToLocal() async {
    final list = groups.map((b) => b.toJson()).toList();
    final jsonStr = json.encode(list);
    await Prefs().instance?.setString(LOCALSTORE_GROUPS, jsonStr);
  }

  Future<void> close() async {
    await subs?.cancel();
    subs = null;
    groups = [];
    notifyListeners();
  }
}
