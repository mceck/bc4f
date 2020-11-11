import 'dart:math';

import 'package:bc4f/utils/app-status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bc4f/utils/logger.dart';

class BarcodeService {
  static Stream<QuerySnapshot> getAll() {
    // this is a test
    final useruid = AppStatus().loggedUser.uid;
    log.info('get all groups for user $useruid');
    final collection = FirebaseFirestore.instance
        .collection('barcode_group')
        .where('user', isEqualTo: useruid)
        .orderBy('order');
    log.info('collection $collection');
    return collection.snapshots();
  }
}
