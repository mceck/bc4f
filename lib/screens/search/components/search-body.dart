import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/screens/barcodes/barcode-card.dart';
import 'package:bc4f/screens/barcodes/view/barcode-view.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:flutter/material.dart';

class SearchBody extends StatelessWidget {
  const SearchBody({
    Key key,
    @required this.barcodes,
  }) : super(key: key);

  final List<Barcode> barcodes;

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
        return GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            BarcodeView.route,
            arguments: {'barcodes': barcodes, 'startIdx': index},
          ),
          child: BarcodeCard(
            barcodes: barcodes,
            index: index,
            showGroup: true,
            withSlideActions: false,
          ),
        );
      },
    );
  }
}
