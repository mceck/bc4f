import 'dart:async';
import 'dart:convert';

import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/model/group.dart';
import 'package:bc4f/model/tag.dart';
import 'package:bc4f/utils/app-status.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/utils/prefs.dart';

class OfflineService {
  StreamController<List<BarcodeGroup>> groups;
  StreamController<List<Tag>> tags;
  StreamController<List<Barcode>> barcodes;

  void init() {
    if (groups == null) groups = StreamController.broadcast();
    if (tags == null) tags = StreamController.broadcast();
    if (barcodes == null) barcodes = StreamController.broadcast();
  }

  void dispose() {
    if (groups != null) groups.close();
    if (tags != null) tags.close();
    if (barcodes != null) barcodes.close();
    groups = null;
    tags = null;
    barcodes = null;
  }

  int _sortGroups(BarcodeGroup a, BarcodeGroup b) =>
      a.order?.compareTo(b.order ?? 0) ?? 0;
  int _sortBarcodes(Barcode a, Barcode b) {
    final cmpGrp = a.group.compareTo(b.group);
    if (cmpGrp == 0) return a.order.compareTo(b.order);
    return cmpGrp;
  }

  List<T> _getFromLocal<T>(String key, T Function(dynamic) factory) {
    final jsonStr = Prefs().instance.getString(key);
    if (jsonStr != null) {
      final List list = json.decode(jsonStr);
      final groupList = list.map(factory).toList();
      return groupList;
    }
    return [];
  }

  Future<void> _saveToLocal<T>(
      String key, List<T> obj, Map<String, dynamic> Function(T) toJson) async {
    final list = obj.map(toJson).toList();
    final jsonStr = json.encode(list);
    await Prefs().instance.setString(key, jsonStr);
  }

  List<BarcodeGroup> _getGroupsFromLocal() => _getFromLocal<BarcodeGroup>(
      LOCALSTORE_GROUPS, (map) => BarcodeGroup.fromJson(map));

  Future<void> _saveGroupsToLocal(List<BarcodeGroup> groups) =>
      _saveToLocal<BarcodeGroup>(LOCALSTORE_GROUPS, groups, (g) => g.toJson());

  List<Tag> _getTagsFromLocal() =>
      _getFromLocal<Tag>(LOCALSTORE_TAGS, (map) => Tag.fromJson(map));

  Future<void> _saveTagsToLocal(List<Tag> tags) =>
      _saveToLocal<Tag>(LOCALSTORE_TAGS, tags, (t) => t.toJson());

  List<Barcode> _getBarcodesFromLocal() => _getFromLocal<Barcode>(
      LOCALSTORE_BARCODES, (map) => Barcode.fromJson(map));

  Future<void> _saveBarcodesToLocal(List<Barcode> barcodes) =>
      _saveToLocal<Barcode>(LOCALSTORE_BARCODES, barcodes, (b) => b.toJson());

  Stream<List<BarcodeGroup>> streamGroups() {
    final groupList = _getGroupsFromLocal();
    Future.delayed(Duration(milliseconds: 100))
        .then((_) => groups.add(groupList));

    return groups.stream;
  }

  Future<void> saveGroup(BarcodeGroup group) async {
    final groupList = _getGroupsFromLocal();
    if (group.uid != null) {
      //update
      groupList.removeWhere((g) => g.uid == group.uid);
    } else {
      group.uid = AppStatus().uuid.v1();
    }
    groupList
      ..add(group)
      ..sort(_sortGroups);
    await _saveGroupsToLocal(groupList);
    groups.add(groupList);
  }

  Future<void> deleteGroup(String uid) async {
    final groupList = _getGroupsFromLocal();
    groupList.removeWhere((g) => g.uid == uid);
    await _saveGroupsToLocal(groupList);
    groups.add(groupList);
  }

  Stream<List<Tag>> streamTags() {
    final tagList = _getTagsFromLocal();
    Future.delayed(Duration(milliseconds: 100)).then((_) => tags.add(tagList));

    return tags.stream;
  }

  Future<void> saveTag(Tag tag) async {
    final tagList = _getTagsFromLocal();
    if (tag.uid != null) {
      //update
      tagList.removeWhere((t) => t.uid == tag.uid);
    } else {
      tag.uid = AppStatus().uuid.v1();
    }
    tagList.add(tag);
    await _saveTagsToLocal(tagList);
    tags.add(tagList);
  }

  Future<void> deleteTag(String uid) async {
    final tagList = _getTagsFromLocal();
    tagList.removeWhere((t) => t.uid == uid);
    await _saveTagsToLocal(tagList);
    tags.add(tagList);
  }

  Future<List<Barcode>> getBarcodes() async {
    return _getBarcodesFromLocal();
  }

  Stream<List<Barcode>> streamBarcodes() {
    final barcodeList = _getBarcodesFromLocal();
    Future.delayed(Duration(milliseconds: 100))
        .then((_) => barcodes.add(barcodeList));

    return barcodes.stream;
  }

  Stream<Barcode> streamBarcode(String uid) {
    throw UnimplementedError();
  }

  Stream<List<Barcode>> streamBarcodesByGroup(String groupId) {
    throw UnimplementedError();
  }

  Future<void> deleteBarcode(String uid) async {
    final barcodeList = _getBarcodesFromLocal();
    barcodeList.removeWhere((g) => g.uid == uid);
    await _saveBarcodesToLocal(barcodeList);
    barcodes.add(barcodeList);
  }

  Future<void> saveBarcode(Barcode barcode) async {
    final barcodeList = _getBarcodesFromLocal();
    if (barcode.uid != null) {
      //update
      barcodeList.removeWhere((g) => g.uid == barcode.uid);
    } else {
      barcode.uid = AppStatus().uuid.v1();
    }
    barcodeList
      ..add(barcode)
      ..sort(_sortBarcodes);
    await _saveBarcodesToLocal(barcodeList);
    barcodes.add(barcodeList);
  }

  static final OfflineService _singleton = OfflineService._internal();

  factory OfflineService() {
    return _singleton;
  }

  OfflineService._internal() {
    init();
  }
}
