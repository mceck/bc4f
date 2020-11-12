import 'package:bc4f/screens/barcodes/form/barcode-form.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/widget/components/barcode-image.dart';
import 'package:bc4f/widget/components/tags.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/barcode.dart';

class BarcodeView extends StatefulWidget {
  static const route = '/barcodes/view';

  final List<Barcode> barcodes;
  final int startIdx;

  const BarcodeView({Key key, this.barcodes, this.startIdx}) : super(key: key);

  @override
  _BarcodeViewState createState() => _BarcodeViewState();
}

class _BarcodeViewState extends State<BarcodeView>
    with TickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(
        initialIndex: widget.startIdx,
        length: widget.barcodes.length,
        vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    if (tabController != null) tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Bc4fScaffold(
      actionEdit: () => Navigator.of(context).pushNamed(
        BarcodeForm.route,
        arguments: {'barcode': widget.barcodes[tabController.index]},
      ),
      body: TabBarView(
        controller: tabController,
        children: widget.barcodes
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
      ),
    );
  }
}
