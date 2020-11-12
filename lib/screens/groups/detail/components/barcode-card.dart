import 'package:barcode/barcode.dart' as bcLib;
import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/screens/barcodes/form/barcode-form.dart';
import 'package:bc4f/screens/barcodes/view/barcode-view.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/widget/components/barcode-image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
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
          actions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => BarcodeService.deleteBarcode(barcode.uid),
            ),
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Edit',
              color: Colors.blue,
              icon: Icons.edit,
              onTap: () => Navigator.of(context).pushNamed(BarcodeForm.route,
                  arguments: {'barcode': barcode}),
            ),
          ],
        ),
      ),
    );
  }
}
