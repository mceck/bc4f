import 'package:barcode/barcode.dart' as bcLib;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class BcFormats {
  static bcLib.BarcodeType mlToBc(BarcodeFormat fmt) {
    if (fmt.value == BarcodeFormat.ean13.value)
      return bcLib.BarcodeType.CodeEAN13;
    if (fmt.value == BarcodeFormat.itf.value) return bcLib.BarcodeType.Itf;
    if (fmt.value == BarcodeFormat.ean8.value)
      return bcLib.BarcodeType.CodeEAN8;
    if (fmt.value == BarcodeFormat.code39.value)
      return bcLib.BarcodeType.Code39;
    if (fmt.value == BarcodeFormat.code93.value)
      return bcLib.BarcodeType.Code93;
    if (fmt.value == BarcodeFormat.upca.value)
      return bcLib.BarcodeType.CodeUPCA;
    if (fmt.value == BarcodeFormat.upce.value)
      return bcLib.BarcodeType.CodeUPCE;
    if (fmt.value == BarcodeFormat.code128.value)
      return bcLib.BarcodeType.Code128;
    if (fmt.value == BarcodeFormat.qrCode.value)
      return bcLib.BarcodeType.QrCode;
    if (fmt.value == BarcodeFormat.codabar.value)
      return bcLib.BarcodeType.Codabar;
    if (fmt.value == BarcodeFormat.pdf417.value)
      return bcLib.BarcodeType.PDF417;
    if (fmt.value == BarcodeFormat.dataMatrix.value)
      return bcLib.BarcodeType.DataMatrix;
    if (fmt.value == BarcodeFormat.aztec.value) return bcLib.BarcodeType.Aztec;

    return bcLib.BarcodeType.CodeEAN13;
  }
}
