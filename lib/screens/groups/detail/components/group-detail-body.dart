import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/screens/barcodes/barcode-card.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:flutter/material.dart';

class GroupDetailBody extends StatelessWidget {
  final List<Barcode> barcodes;

  const GroupDetailBody({Key key, this.barcodes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: 4 / 3,
          maxCrossAxisExtent: 330,
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
      ),
    );
  }
}
