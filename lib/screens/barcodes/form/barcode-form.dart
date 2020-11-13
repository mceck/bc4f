import 'package:bc4f/screens/barcodes/form/components/barcode-form-body.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/barcode.dart';

class BarcodeForm extends StatelessWidget {
  static const route = '/barcodes/form';

  final Barcode barcode;

  const BarcodeForm({Key key, this.barcode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bc4fScaffold(
      body: BarcodeFormBody(barcode: barcode),
    );
  }
}
