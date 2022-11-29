import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

Future<String> barcodeScanner() async {
  return await FlutterBarcodeScanner.scanBarcode(
      'red', "cancel", true, ScanMode.BARCODE);
}
