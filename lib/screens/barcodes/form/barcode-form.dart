import 'package:flutter/material.dart';
import 'package:bc4f/model/barcode.dart';

class BarcodeForm extends StatefulWidget {
  static const route = '/barcodes/form';

  final Barcode barcode;

  const BarcodeForm({Key key, this.barcode}) : super(key: key);

  @override
  _BarcodeFormState createState() => _BarcodeFormState();
}

class _BarcodeFormState extends State<BarcodeForm> {
  @override
  Widget build(BuildContext context) {
    return Text('Not implemented');
  }
}
