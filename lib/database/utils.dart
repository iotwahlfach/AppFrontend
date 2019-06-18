import 'package:kaufland_qr/database/databaseHelper.dart';
import 'package:kaufland_qr/models/qrcode.dart';

class Utils {
  Future<int> insertPendingQRCode(QRCode qrCode) async {
    var pendingQrCodes = await DatabaseHelper.instance.getQRCodesByStatus(0);
    var deleted =
        await DatabaseHelper.instance.deleteQrCode(pendingQrCodes.first.id);
    if (deleted) {
      var id = DatabaseHelper.instance.insertQrCode(qrCode);
      return id;
    }
  }
}
