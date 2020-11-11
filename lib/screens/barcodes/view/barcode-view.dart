import 'package:flutter/material.dart';
import 'package:bc4f/model/barcode.dart';

class BarcodeView extends StatefulWidget {
  static const route = '/barcodes/view';

  final List<Barcode> barcodes;
  final int startIdx;

  const BarcodeView({Key key, this.barcodes, this.startIdx}) : super(key: key);

  @override
  _BarcodeViewState createState() => _BarcodeViewState();
}

class _BarcodeViewState extends State<BarcodeView> {
  @override
  Widget build(BuildContext context) {
    return Text('Not implemented');
  }
}
