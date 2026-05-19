import 'package:flutter/material.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BarcodeImage extends StatelessWidget {
  final String code;
  final BarcodeType barcodeType;
  final double? width;
  final double? height;
  final BoxFit fit;

  const BarcodeImage(
    this.code,
    this.barcodeType, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final bc = Barcode.fromType(barcodeType);
    final svgString = bc.toSvg(code);
    return SvgPicture.string(
      svgString,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
