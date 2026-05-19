import 'package:bc4f/provider/recent-barcode-provider.dart';
import 'package:bc4f/screens/barcodes/form/barcode-form.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/barcode.dart';
import 'package:provider/provider.dart';

import 'components/barcode-view-body.dart';

class BarcodeView extends StatefulWidget {
  static const route = '/barcodes/view';

  final List<Barcode> barcodes;
  final int startIdx;

  const BarcodeView({
    super.key,
    required this.barcodes,
    required this.startIdx,
  });

  @override
  State<BarcodeView> createState() => _BarcodeViewState();
}

class _BarcodeViewState extends State<BarcodeView>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      initialIndex: widget.startIdx,
      length: widget.barcodes.length,
      vsync: this,
    );

    Provider.of<RecentBarcodeProvider>(context, listen: false)
        .pushRecent(widget.barcodes[widget.startIdx]);

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Bc4fScaffold(
      title: const Text('Barcode'),
      actionEdit: () => Navigator.of(context).pushNamed(
        BarcodeForm.route,
        arguments: {'barcode': widget.barcodes[tabController.index]},
      ),
      withExtendedAppbar: false,
      body: BarcodeViewBody(
        tabController: tabController,
        barcodes: widget.barcodes,
      ),
    );
  }
}
