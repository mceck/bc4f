import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/screens/barcodes/view/barcode-view.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/widget/components/barcode-image.dart';
import 'package:bc4f/widget/components/tags.dart';
import 'package:flutter/material.dart';

class BarcodeViewBody extends StatelessWidget {
  const BarcodeViewBody({
    Key key,
    @required this.tabController,
    this.barcodes,
  }) : super(key: key);

  final TabController tabController;
  final List<Barcode> barcodes;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: barcodes
          .map(
            (barcode) => Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  if (barcode.tags != null) TagList(tags: barcode.tags),
                  Expanded(
                    child: BarcodeImage(
                      barcode.code ?? 'null',
                      barcode.type,
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                  ),
                  Text(barcode.description ?? 'null'),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}