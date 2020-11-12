import 'dart:math';

import 'package:bc4f/utils/app-status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bc4f/utils/logger.dart';

class BarcodeService {
  static Stream<QuerySnapshot> getAll() {
    final useruid = AppStatus().loggedUser.uid;
    log.info('get all groups for user $useruid');
    final collection = FirebaseFirestore.instance
        .collection('barcode_group')
        .where('user', isEqualTo: useruid)
        .orderBy('order');
    log.info('collection $collection');
    return collection.snapshots();
  }

  static Stream<DocumentSnapshot> getBarcode(String uid) {
    final result = FirebaseFirestore.instance.collection('barcode').doc(uid);
    log.info('result $result');
    return result.snapshots();
  }
}
