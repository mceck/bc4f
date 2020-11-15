import 'package:bc4f/model/barcode.dart';
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
              padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
              child: Column(
                children: [
                  if (barcode.name != null)
                    Text(
                      barcode.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: Colors.black),
                    ),
                  Text(
                    barcode.description ?? 'null',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: Colors.grey[850]),
                  ),
                  SizedBox(height: kDefaultPadding * 2),
                  Expanded(
                    child: BarcodeImage(
                      barcode.code ?? 'null',
                      barcode.type,
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                  ),
                  if (barcode.tags != null)
                    DefaultTextStyle(
                      child: TagList(tags: barcode.tags),
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: Colors.white),
                    ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
