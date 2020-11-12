import 'package:barcode/barcode.dart' as bcLib;
import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/screens/barcodes/view/barcode-view.dart';
import 'package:bc4f/widget/components/barcode-image.dart';
import 'package:flutter/material.dart';

class BarcodeCard extends StatelessWidget {
  final List<Barcode> barcodes;
  final int index;

  const BarcodeCard({Key key, this.barcodes, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final barcode = barcodes[index];
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        BarcodeView.route,
        arguments: {'barcodes': barcodes, 'startIdx': index},
      ),
      child: Card(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Image.network(
                barcode.imgUrl ?? '',
                errorBuilder: (ctx, err, stack) {
                  return BarcodeImage(
                    barcode.code ?? '',
                    barcode.type ?? bcLib.BarcodeType.CodeEAN13,
                    width: 200,
                  );
                },
              ),
            ),
            Flexible(
              flex: 1,
              child: ListTile(
                title: Text(barcode.code ?? 'null'),
                subtitle: Text(barcode.description ?? 'null'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
