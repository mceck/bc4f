import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/screens/barcodes/form/barcode-form.dart';
import 'package:bc4f/screens/barcodes/view/barcode-view.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/widget/components/barcode-image.dart';
import 'package:bc4f/widget/components/tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BarcodeCard extends StatelessWidget {
  final List<Barcode> barcodes;
  final int index;
  final bool withSlideActions;
  final bool showGroup;
  final bool showTags;
  final bool showName;

  const BarcodeCard({
    super.key,
    required this.barcodes,
    required this.index,
    this.withSlideActions = false,
    this.showGroup = false,
    this.showTags = true,
    this.showName = true,
  });

  @override
  Widget build(BuildContext context) {
    final barcode = barcodes[index];
    final nameVisual =
        barcode.name != null && barcode.name!.isNotEmpty
            ? barcode.name!
            : barcode.code ?? 'null';
    final fallbackImg = BarcodeImage(
      barcode.code ?? '',
      barcode.type,
      width: 220,
    );
    final cardContent = Column(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Image.network(
              barcode.imgUrl ?? '',
              loadingBuilder: (ctx, child, progress) =>
                  progress != null ? fallbackImg : child,
              errorBuilder: (ctx, error, stackTrace) => fallbackImg,
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: ListTile(
            title: showName
                ? Text(nameVisual, textAlign: TextAlign.center)
                : null,
            subtitle: Column(
              children: [
                Text(barcode.description ?? 'null'),
                if (showGroup)
                  Text('group: ${barcode.group ?? 'null'}'),
                if (showTags) TagList(tags: barcode.tags),
              ],
            ),
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        BarcodeView.route,
        arguments: {
          'barcodes': List<Barcode>.from(barcodes),
          'startIdx': index,
        },
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: withSlideActions
            ? Slidable(
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: (_) =>
                          BarcodeService.deleteBarcode(barcode.uid!),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: (_) => Navigator.of(context).pushNamed(
                          BarcodeForm.route,
                          arguments: {'barcode': barcode}),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  ],
                ),
                child: cardContent,
              )
            : cardContent,
      ),
    );
  }
}
