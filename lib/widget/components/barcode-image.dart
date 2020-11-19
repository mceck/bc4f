import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:svg_web/svg_web.dart';

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
      return SvgWeb(
        svgString: svgString,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
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
