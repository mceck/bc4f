import 'package:barcode/barcode.dart' as bcLib;
import 'package:bc4f/utils/formatters.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/widget/components/ml-vision-camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class _BarcodeScanner extends StatefulWidget {
  @override
  __BarcodeScannerState createState() => __BarcodeScannerState();
}

class __BarcodeScannerState extends State<_BarcodeScanner> {
  bool resultSent = false;

  @override
  Widget build(BuildContext context) {
    return CameraMlVision<List<Barcode>>(
      detector: FirebaseVision.instance
          .barcodeDetector(BarcodeDetectorOptions(
              barcodeFormats: BarcodeFormat.ean13 | BarcodeFormat.code128))
          .detectInImage,
      onResult: (List<Barcode> barcodes) {
        if (!mounted ||
            resultSent ||
            barcodes == null ||
            barcodes.length == 0 ||
            barcodes.first.format.value == -1) {
          if (barcodes != null && barcodes.isNotEmpty)
            log.fine(
                'suppress bc read ${barcodes?.first?.displayValue} type ${barcodes?.first?.format?.value}');
          return;
        }
        resultSent = true;
        final result = ScanResult();
        final bc = barcodes.first;
        result.code = bc.displayValue;
        result.type = BcFormats.mlToBc(bc.format);
        log.info('readed barcode ${bc.displayValue} type: ${bc.format.value}');
        Navigator.of(context).pop<ScanResult>(result);
      },
    );
  }
}

class ScanResult {
  String code;
  bcLib.BarcodeType type;
}

Future<ScanResult> scanBarcode(BuildContext context) {
  return Navigator.of(context)
      .push(MaterialPageRoute(builder: (ctx) => _BarcodeScanner()));
}
