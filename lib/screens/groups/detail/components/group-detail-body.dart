import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/screens/barcodes/barcode-card.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

class GroupDetailBody extends StatelessWidget {
  final List<Barcode> barcodes;

  const GroupDetailBody({Key key, this.barcodes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReorderableWrap(
        runSpacing: kDefaultPadding,
        spacing: kDefaultPadding,
        children: [
          for (int index = 0; index < barcodes.length; index++)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: AspectRatio(
                aspectRatio: kDefaultGridCellAspectRatio,
                child: BarcodeCard(
                  barcodes: barcodes,
                  index: index,
                  withSlideActions: true,
                ),
              ),
            ),
        ],
        onReorder: (from, to) {
          log.info('from $from to $to');
          BarcodeService.reorderBarcode(barcodes, from, to);
        });
  }
}
