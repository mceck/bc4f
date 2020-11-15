import 'package:bc4f/screens/barcodes/form/components/barcode-form-body.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/widget/components/tags.dart';
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
    final isNew = barcode?.uid == null;
    return Bc4fScaffold(
      title: Text(isNew ? 'Add barcode' : 'Edit barcode'),
      subtitle: isNew
          ? Text('Add a new barcode')
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: kDefaultPadding / 2),
                  child: Text(
                    barcode.code,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (barcode.name != null && barcode.name.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: kDefaultPadding / 2),
                    child: Text(
                      barcode.name,
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (barcode.description != null &&
                    barcode.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: kDefaultPadding / 2),
                    child: Text(
                      barcode.description,
                      textAlign: TextAlign.center,
                    ),
                  ),
                TagList(tags: barcode.tags)
              ],
            ),
      body: BarcodeFormBody(barcode: barcode),
    );
  }
}
