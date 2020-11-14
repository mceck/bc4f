import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/screens/barcodes/barcode-card.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:flutter/material.dart';

class GroupDetailBody extends StatelessWidget {
  final List<Barcode> barcodes;

  const GroupDetailBody({Key key, this.barcodes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        childAspectRatio: kDefaultGridCellAspectRatio,
        maxCrossAxisExtent: kDefaultGridMaxExtent,
        crossAxisSpacing: kDefaultPadding,
        mainAxisSpacing: kDefaultPadding,
      ),
      itemCount: barcodes.length,
      itemBuilder: (ctx, index) {
        return BarcodeCard(
          barcodes: barcodes,
          index: index,
          withSlideActions: true,
        );
      },
    );
  }
}
