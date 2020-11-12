import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseQueryBuilder<T> extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  final Widget Function(BuildContext, List<T>) builder;
  final T Function(Map<String, dynamic>) factoryMethod;

  const FirebaseQueryBuilder({
    Key key,
    @required this.stream,
    @required this.builder,
    @required this.factoryMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (ctx, snapshot) {
          if (snapshot.hasError)
            return Center(
              child: SelectableText('Error: ${snapshot.error}'),
            );
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          final list = snapshot.data.docs
              .map((doc) => factoryMethod(doc.data()))
              .toList();
          return builder(ctx, list);
        });
  }
}

class FirebaseDocumentBuilder<T> extends StatelessWidget {
  final Stream<DocumentSnapshot> stream;
  final Widget Function(BuildContext, T) builder;
  final T Function(Map<String, dynamic>) factoryMethod;

  const FirebaseDocumentBuilder(
      {Key key, this.stream, this.builder, this.factoryMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: stream,
        builder: (ctx, snapshot) {
          if (snapshot.hasError)
            return Center(
              child: SelectableText('Error: ${snapshot.error}'),
            );
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          final doc = factoryMethod(snapshot.data.data());
          return builder(ctx, doc);
        });
  }
}
