import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseQueryBuilder<T> extends StatelessWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> stream;
  final Widget Function(BuildContext, List<T>) builder;
  final T Function(Map<String, dynamic>) factoryMethod;

  const FirebaseQueryBuilder({
    super.key,
    required this.stream,
    required this.builder,
    required this.factoryMethod,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: stream,
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: SelectableText('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snapshot.data!.docs
              .map((doc) => factoryMethod(doc.data()))
              .toList();
          return builder(ctx, list);
        });
  }
}

class FirebaseDocumentBuilder<T> extends StatelessWidget {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> stream;
  final Widget Function(BuildContext, T?) builder;
  final T Function(Map<String, dynamic>) factoryMethod;

  const FirebaseDocumentBuilder(
      {super.key,
      required this.stream,
      required this.builder,
      required this.factoryMethod});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: stream,
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: SelectableText('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data?.data();
          final doc = data != null ? factoryMethod(data) : null;
          return builder(ctx, doc);
        });
  }
}
