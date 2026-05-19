import 'package:barcode/barcode.dart' as bcLib;
import 'package:mobile_scanner/mobile_scanner.dart' as ms;

class BcFormats {
  static bcLib.BarcodeType mobileScannerToBc(ms.BarcodeFormat fmt) {
    switch (fmt) {
      case ms.BarcodeFormat.ean13:
        return bcLib.BarcodeType.CodeEAN13;
      case ms.BarcodeFormat.itf14:
        return bcLib.BarcodeType.Itf;
      case ms.BarcodeFormat.ean8:
        return bcLib.BarcodeType.CodeEAN8;
      case ms.BarcodeFormat.code39:
        return bcLib.BarcodeType.Code39;
      case ms.BarcodeFormat.code93:
        return bcLib.BarcodeType.Code93;
      case ms.BarcodeFormat.upcA:
        return bcLib.BarcodeType.CodeUPCA;
      case ms.BarcodeFormat.upcE:
        return bcLib.BarcodeType.CodeUPCE;
      case ms.BarcodeFormat.code128:
        return bcLib.BarcodeType.Code128;
      case ms.BarcodeFormat.qrCode:
        return bcLib.BarcodeType.QrCode;
      case ms.BarcodeFormat.codabar:
        return bcLib.BarcodeType.Codabar;
      case ms.BarcodeFormat.pdf417:
        return bcLib.BarcodeType.PDF417;
      case ms.BarcodeFormat.dataMatrix:
        return bcLib.BarcodeType.DataMatrix;
      case ms.BarcodeFormat.aztec:
        return bcLib.BarcodeType.Aztec;
      default:
        return bcLib.BarcodeType.CodeEAN13;
    }
  }
}
