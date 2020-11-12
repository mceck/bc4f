import 'dart:math';

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
}
