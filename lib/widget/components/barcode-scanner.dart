import 'package:barcode/barcode.dart' as bcLib;
import 'package:bc4f/utils/formatters.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as ms;

class ScanResult {
  String? code;
  bcLib.BarcodeType? type;
}

Future<ScanResult?> scanBarcode(BuildContext context) {
  return Navigator.of(context).push<ScanResult?>(
    MaterialPageRoute(builder: (ctx) => const _BarcodeScannerScreen()),
  );
}

class _BarcodeScannerScreen extends StatefulWidget {
  const _BarcodeScannerScreen();

  @override
  State<_BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<_BarcodeScannerScreen> {
  bool _resultSent = false;

  void _onDetect(ms.BarcodeCapture capture) {
    if (!mounted || _resultSent || capture.barcodes.isEmpty) return;
    final bc = capture.barcodes.first;
    final value = bc.rawValue ?? bc.displayValue;
    if (value == null || value.isEmpty) return;

    _resultSent = true;
    final result = ScanResult()
      ..code = value
      ..type = BcFormats.mobileScannerToBc(bc.format);

    log.info('scanned barcode $value type: ${bc.format}');
    Navigator.of(context).pop<ScanResult>(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan barcode'),
        elevation: 0,
      ),
      body: ms.MobileScanner(
        onDetect: _onDetect,
      ),
    );
  }
}
