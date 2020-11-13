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
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          // childAspectRatio: 4 / 3,
          maxCrossAxisExtent: 400,
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
      ),
    );
  }
}
