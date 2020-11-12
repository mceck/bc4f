import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/screens/groups/detail/components/barcode-card.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:flutter/material.dart';

class GroupGrid extends StatelessWidget {
  final List<Barcode> barcodes;

  const GroupGrid({Key key, this.barcodes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        childAspectRatio: 4 / 3,
        maxCrossAxisExtent: 330,
        crossAxisSpacing: kDefaultPadding,
        mainAxisSpacing: kDefaultPadding,
      ),
      itemCount: barcodes.length,
      itemBuilder: (ctx, index) {
        return BarcodeCard(barcodes: barcodes, index: index);
      },
    );
  }
}
