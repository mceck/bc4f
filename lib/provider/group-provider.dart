import 'dart:async';

import 'package:bc4f/model/group.dart';
import 'package:bc4f/service/barcode-service.dart';
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
        groups =
            snap.docs.map((doc) => BarcodeGroup.fromJson(doc.data())).toList();
        notifyListeners();
      });
  }

  Future<void> close() async {
    if (subs != null) await subs.cancel();
    subs = null;
    groups = [];
    notifyListeners();
  }
}
