import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:bc4f/utils/fake-html.dart' if (dart.library.html) 'dart:html'
    as html;
import 'package:bc4f/utils/fake-ui.dart' if (dart.library.html) 'dart:ui' as ui;

const kUndraggableCss =
    'user-drag: none;user-select: none;-moz-user-select: none;-webkit-user-drag: none;-webkit-user-select: none;-ms-user-select: none;';

class BarcodeImage extends StatefulWidget {
  final String code;
  final BarcodeType barcodeType;
  final double width;
  final double height;
  final BoxFit fit;

  const BarcodeImage(
    this.code,
    this.barcodeType, {
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  _BarcodeImageState createState() => _BarcodeImageState();
}

class _BarcodeImageState extends State<BarcodeImage> {
  final _random = Random();
  @override
  Widget build(BuildContext context) {
    // Create a DataMatrix barcode
    final bc = Barcode.fromType(widget.barcodeType);

    final svgString = bc.toSvg(widget.code);
    if (kIsWeb) {
      // TODO rivedi dimensionamento
      final height = widget.height ?? widget.width;
      final width = widget.width ?? widget.height;
      // log.info('web $width x $height');
      String hashCode = String.fromCharCodes(
          List<int>.generate(128, (i) => _random.nextInt(256)));
      ui.platformViewRegistry.registerViewFactory('img-svg-$hashCode',
          (int viewId) {
        final String base64 = base64Encode(utf8.encode(svgString));
        final String base64String = 'data:image/svg+xml;base64,$base64';
        final html.ImageElement element = html.ImageElement(
          src: base64String,
          width: width.toInt(),
          height: height.toInt(),
        )..setAttribute('style', kUndraggableCss);
        return element;
      });
      return Container(
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        child: AbsorbPointer(
          child: HtmlElementView(
            viewType: 'img-svg-$hashCode',
          ),
        ),
      );
    }

    return SvgPicture.string(
      svgString,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
    );
  }
}
