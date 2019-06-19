import 'package:kaufland_qr/database/databaseHelper.dart';
import 'package:kaufland_qr/models/qrcode.dart';
import 'package:kaufland_qr/models/station.dart';

class Utils {
  Future<int> insertPendingQRCode(QRCode qrCode) async {
    var pendingQrCodes = await DatabaseHelper.instance.getQRCodesByStatus(0);
    if (!pendingQrCodes.isEmpty) {
      var deleted =
          await DatabaseHelper.instance.deleteQrCode(pendingQrCodes.first.id);
    }

    var id = await DatabaseHelper.instance.insertQrCode(qrCode);
    return id;
  }
}
