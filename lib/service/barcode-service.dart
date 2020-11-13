import 'dart:math';

import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/model/group.dart';
import 'package:bc4f/model/tag.dart';
import 'package:bc4f/utils/app-status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bc4f/utils/logger.dart';

class BarcodeService {
  static Stream<QuerySnapshot> streamGroups() {
    final useruid = AppStatus().loggedUser.uid;
    log.info('stream all groups for user $useruid');
    final collection = FirebaseFirestore.instance
        .collection('barcode_group')
        .where('user', isEqualTo: useruid)
        .orderBy('order');
    log.info('collection $collection');
    return collection.snapshots();
  }

  static Future<void> saveGroup(BarcodeGroup group) {
    final isNew = (group.uid == null);
    final data = group.toJson();
    DocumentReference doc;
    if (isNew) {
      doc = FirebaseFirestore.instance.collection('barcode_group').doc();
    } else {
      doc =
          FirebaseFirestore.instance.collection('barcode_group').doc(group.uid);
    }
    data['user'] = AppStatus().loggedUser.uid;
    data['uid'] = doc.id;
    return doc.set(data);
  }

  static Future<void> deleteGroup(String uid) async {
    final useruid = AppStatus().loggedUser.uid;
    // elimina anche tutti i barcode associati al gruppo
    final snap = await FirebaseFirestore.instance
        .collection('barcode')
        .where('user', isEqualTo: useruid)
        .where('group', isEqualTo: uid)
        .get();
    await Future.forEach<QueryDocumentSnapshot>(
        snap.docs, (doc) => doc.reference.delete());
    await FirebaseFirestore.instance
        .collection('barcode_group')
        .doc(uid)
        .delete();
  }

  static Stream<QuerySnapshot> streamTags() {
    final useruid = AppStatus().loggedUser.uid;
    log.info('stream all tags for user $useruid');
    final collection = FirebaseFirestore.instance
        .collection('tag')
        .where('user', isEqualTo: useruid);
    log.info('collection $collection');
    return collection.snapshots();
  }

  static Future<void> saveTag(Tag tag) {
    final isNew = (tag.uid == null);
    final data = tag.toJson();
    DocumentReference doc;
    if (isNew) {
      doc = FirebaseFirestore.instance.collection('tag').doc();
    } else {
      doc = FirebaseFirestore.instance.collection('tag').doc(tag.uid);
    }
    data['user'] = AppStatus().loggedUser.uid;
    data['uid'] = doc.id;
    return doc.set(data);
  }

  static Future<void> deleteTag(String uid) async {
    final useruid = AppStatus().loggedUser.uid;
    // rimuovo tutti i riferimenti al tag
    final data = await FirebaseFirestore.instance
        .collection('barcode')
        .where('user', isEqualTo: useruid)
        .where('tags', arrayContains: uid)
        .get();
    await Future.forEach(data.docs, (doc) {
      final json = doc.data();
      json['tags']?.remove(uid);
      return doc.reference.set(json);
    });
    await FirebaseFirestore.instance.collection('tag').doc(uid).delete();
  }

  static Future<List<Barcode>> getBarcodes() async {
    final useruid = AppStatus().loggedUser.uid;
    final result = await FirebaseFirestore.instance
        .collection('barcode')
        .where('user', isEqualTo: useruid)
        .orderBy('group')
        .orderBy('order')
        .get();
    log.info('result $result');
    return result.docs.map((doc) => Barcode.fromJson(doc.data())).toList();
  }

  static Stream<QuerySnapshot> streamBarcodes() {
    final useruid = AppStatus().loggedUser.uid;
    log.info('stream all barcodes for user $useruid');
    final collection = FirebaseFirestore.instance
        .collection('barcode')
        .where('user', isEqualTo: useruid)
        .orderBy('group')
        .orderBy('order');
    log.info('collection $collection');
    return collection.snapshots();
  }

  static Stream<DocumentSnapshot> streamBarcode(String uid) {
    final result = FirebaseFirestore.instance.collection('barcode').doc(uid);
    log.info('result $result');
    return result.snapshots();
  }

  static Stream<QuerySnapshot> streamBarcodesByGroup(String groupId) {
    final useruid = AppStatus().loggedUser.uid;
    log.info('get all groups for user $useruid');
    final collection = FirebaseFirestore.instance
        .collection('barcode')
        .where('user', isEqualTo: useruid)
        .where('group', isEqualTo: groupId)
        .orderBy('order');
    log.info('collection $collection');
    return collection.snapshots();
  }

  static Future<void> deleteBarcode(String uid) {
    return FirebaseFirestore.instance.collection('barcode').doc(uid).delete();
  }

  static Future<void> saveBarcode(Barcode barcode) {
    final isNew = (barcode.uid == null);
    final data = barcode.toJson();
    DocumentReference doc;
    if (isNew) {
      doc = FirebaseFirestore.instance.collection('barcode').doc();
    } else {
      doc = FirebaseFirestore.instance.collection('barcode').doc(barcode.uid);
    }
    data['user'] = AppStatus().loggedUser.uid;
    data['uid'] = doc.id;
    return doc.set(data);
  }
}
