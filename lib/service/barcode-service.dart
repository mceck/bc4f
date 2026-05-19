import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/model/group.dart';
import 'package:bc4f/model/tag.dart';
import 'package:bc4f/service/offline-service.dart';
import 'package:bc4f/utils/app-status.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bc4f/utils/logger.dart';

class BarcodeService {
  static Stream<List<BarcodeGroup>> streamGroups() {
    if (AppStatus().offlineMode) return OfflineService().streamGroups();
    final useruid = AppStatus().loggedUser!.uid;
    log.info('stream all groups for user $useruid');
    final collection = FirebaseFirestore.instance
        .collection('barcode_group')
        .where('user', isEqualTo: useruid)
        .orderBy('order');
    return collection.snapshots().map((snap) =>
        snap.docs.map((doc) => BarcodeGroup.fromJson(doc.data())).toList());
  }

  static Future<void> saveGroup(BarcodeGroup group) {
    if (AppStatus().offlineMode) return OfflineService().saveGroup(group);
    final isNew = group.uid == null;
    final data = group.toJson();
    DocumentReference doc;
    if (isNew) {
      doc = FirebaseFirestore.instance.collection('barcode_group').doc();
    } else {
      doc = FirebaseFirestore.instance
          .collection('barcode_group')
          .doc(group.uid);
    }
    data['user'] = AppStatus().loggedUser!.uid;
    data['uid'] = doc.id;
    return doc.set(data);
  }

  static Future<void> deleteGroup(String uid) async {
    if (AppStatus().offlineMode) return OfflineService().deleteGroup(uid);
    final useruid = AppStatus().loggedUser!.uid;
    final snap = await FirebaseFirestore.instance
        .collection('barcode')
        .where('user', isEqualTo: useruid)
        .where('group', isEqualTo: uid)
        .get();
    await Future.forEach<QueryDocumentSnapshot<Map<String, dynamic>>>(
        snap.docs, (doc) => doc.reference.delete());
    await FirebaseFirestore.instance
        .collection('barcode_group')
        .doc(uid)
        .delete();
  }

  static Stream<List<Tag>> streamTags() {
    if (AppStatus().offlineMode) return OfflineService().streamTags();
    final useruid = AppStatus().loggedUser!.uid;
    log.info('stream all tags for user $useruid');
    final collection = FirebaseFirestore.instance
        .collection('tag')
        .where('user', isEqualTo: useruid)
        .orderBy('order');
    return collection.snapshots().map(
        (snap) => snap.docs.map((doc) => Tag.fromJson(doc.data())).toList());
  }

  static Future<void> saveTag(Tag tag) {
    if (AppStatus().offlineMode) return OfflineService().saveTag(tag);
    final isNew = tag.uid == null;
    final data = tag.toJson();
    DocumentReference doc;
    if (isNew) {
      doc = FirebaseFirestore.instance.collection('tag').doc();
    } else {
      doc = FirebaseFirestore.instance.collection('tag').doc(tag.uid);
    }
    data['user'] = AppStatus().loggedUser!.uid;
    data['uid'] = doc.id;
    return doc.set(data);
  }

  static Future<void> deleteTag(String uid) async {
    if (AppStatus().offlineMode) return OfflineService().deleteTag(uid);
    final useruid = AppStatus().loggedUser!.uid;
    final data = await FirebaseFirestore.instance
        .collection('barcode')
        .where('user', isEqualTo: useruid)
        .where('tags', arrayContains: uid)
        .get();
    await Future.forEach<QueryDocumentSnapshot<Map<String, dynamic>>>(
        data.docs, (doc) {
      final json = Map<String, dynamic>.from(doc.data());
      (json['tags'] as List?)?.remove(uid);
      return doc.reference.set(json);
    });
    await FirebaseFirestore.instance.collection('tag').doc(uid).delete();
  }

  static Future<List<Barcode>> getBarcodes() async {
    if (AppStatus().offlineMode) return OfflineService().getBarcodes();
    final useruid = AppStatus().loggedUser!.uid;
    final result = await FirebaseFirestore.instance
        .collection('barcode')
        .where('user', isEqualTo: useruid)
        .orderBy('group')
        .orderBy('order')
        .get();
    log.info('result $result');
    return result.docs.map((doc) => Barcode.fromJson(doc.data())).toList();
  }

  static Stream<List<Barcode>> streamBarcodes() {
    if (AppStatus().offlineMode) return OfflineService().streamBarcodes();
    final useruid = AppStatus().loggedUser!.uid;
    log.info('stream all barcodes for user $useruid');
    final collection = FirebaseFirestore.instance
        .collection('barcode')
        .where('user', isEqualTo: useruid)
        .orderBy('group')
        .orderBy('order');
    return collection.snapshots().map((snap) =>
        snap.docs.map((doc) => Barcode.fromJson(doc.data())).toList());
  }

  static Stream<Barcode?> streamBarcode(String uid) {
    if (AppStatus().offlineMode) return OfflineService().streamBarcode(uid);
    final result = FirebaseFirestore.instance.collection('barcode').doc(uid);
    return result.snapshots().map((snap) {
      final data = snap.data();
      return data != null ? Barcode.fromJson(data) : null;
    });
  }

  static Stream<List<Barcode>> streamBarcodesByGroup(String groupId) {
    if (AppStatus().offlineMode) {
      return OfflineService().streamBarcodesByGroup(groupId);
    }
    final useruid = AppStatus().loggedUser!.uid;
    log.info('get all barcodes for group $groupId user $useruid');
    final collection = FirebaseFirestore.instance
        .collection('barcode')
        .where('user', isEqualTo: useruid)
        .where('group', isEqualTo: groupId)
        .orderBy('order');
    return collection.snapshots().map(
        (snap) => snap.docs.map((doc) => Barcode.fromJson(doc.data())).toList());
  }

  static Future<void> deleteBarcode(String uid) {
    if (AppStatus().offlineMode) return OfflineService().deleteBarcode(uid);
    return FirebaseFirestore.instance.collection('barcode').doc(uid).delete();
  }

  static Future<void> saveBarcode(Barcode barcode) {
    if (AppStatus().offlineMode) return OfflineService().saveBarcode(barcode);
    final isNew = barcode.uid == null;
    final data = barcode.toJson();
    DocumentReference doc;
    if (isNew) {
      doc = FirebaseFirestore.instance.collection('barcode').doc();
    } else {
      doc = FirebaseFirestore.instance.collection('barcode').doc(barcode.uid);
    }
    data['user'] = AppStatus().loggedUser!.uid;
    data['uid'] = doc.id;
    return doc.set(data);
  }

  static Future<void> _reorder(
      String collection, List<dynamic> list, int from, int to) async {
    dynamic prev;
    if (from > to) {
      if (to > 0) prev = list[to - 1];
    } else {
      prev = list[to];
    }
    dynamic next;
    if (from > to) {
      next = list[to];
    } else {
      if (to < list.length) next = list[to + 1];
    }
    final src = list[from];
    if (prev != null) {
      final dist = next != null ? next.order - prev.order : kOrderingDistance;
      if (dist < 2) {
        list.removeAt(from);
        list.insert(to, src);
        await _resetOrder(collection, list);
      } else {
        src.order = prev.order + dist ~/ 2;
        await FirebaseFirestore.instance
            .collection(collection)
            .doc(src.uid)
            .update({'order': src.order});
      }
    } else {
      if (next.order < 1) {
        list.removeAt(from);
        list.insert(to, src);
        await _resetOrder(collection, list);
      } else {
        src.order = next.order ~/ 2;
        await FirebaseFirestore.instance
            .collection(collection)
            .doc(src.uid)
            .update({'order': src.order});
      }
    }
  }

  static Future<void> _resetOrder(String collection, List<dynamic> list) async {
    for (int i = 0; i < list.length; i++) {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(list[i].uid)
          .update({'order': (i + 1) * kOrderingDistance});
    }
  }

  static Future<void> _deleteCollection(
      String user, String collectionName) async {
    final collection = await FirebaseFirestore.instance
        .collection(collectionName)
        .where('user', isEqualTo: user)
        .get();
    for (int i = 0; i < collection.size; i++) {
      await collection.docs[i].reference.delete();
    }
  }

  static Future<Map<String, String>> _copyCollection(
      String collectionName, String user,
      [Map<String, String>? groupMap,
      Map<String, String>? tagMap]) async {
    final useruid = AppStatus().loggedUser!.uid;
    log.info('query start');
    var collection = (await FirebaseFirestore.instance
            .collection(collectionName)
            .where('user', isEqualTo: useruid)
            .get())
        .docs;
    log.info('read ok');
    final Map<String, String> retMap = {};
    for (int i = 0; i < collection.length; i++) {
      final doc = Map<String, dynamic>.from(collection[i].data());
      final newDoc =
          FirebaseFirestore.instance.collection(collectionName).doc();
      doc['user'] = user;
      retMap[doc['uid'] as String] = newDoc.id;
      doc['uid'] = newDoc.id;
      if (collectionName == 'barcode') {
        doc['group'] = groupMap?[doc['group'] as String];
        if (doc['tags'] != null) {
          doc['tags'] =
              (doc['tags'] as List).map((t) => tagMap?[t as String]).toList();
        }
      }
      await newDoc.set(doc);
    }
    log.info('copied ${collection.length} $collectionName');
    return retMap;
  }

  static Future<void> reorderGroup(
          List<BarcodeGroup> groups, int from, int to) =>
      _reorder('barcode_group', groups, from, to);

  static Future<void> reorderBarcode(
          List<Barcode> barcodes, int from, int to) =>
      _reorder('barcode', barcodes, from, to);

  static void reorderTag(List<Tag> tags, int from, int to) =>
      _reorder('tag', tags, from, to);

  static Future<void> copyUser(String user) async {
    await _deleteCollection(user, 'barcode_group');
    final groupMap = await _copyCollection('barcode_group', user);
    await _deleteCollection(user, 'tag');
    final tagMap = await _copyCollection('tag', user);
    await _deleteCollection(user, 'barcode');
    await _copyCollection('barcode', user, groupMap, tagMap);
  }
}
