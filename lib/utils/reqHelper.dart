import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kaufland_qr/models/qrcode.dart';
import 'package:kaufland_qr/models/station.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReqHelper {
  Future<Station> getUsedAction() async {
    http.Response response =
        await http.get('http://10.0.2.2:8082/v1/action/smartphone');

    if (response.statusCode == 200) {
      var decodedJson = json.decode(response.body);
      print(decodedJson);
      if (decodedJson["result"] == 1) {
        return Station(
            id: decodedJson["stationId"], name: decodedJson["stationName"]);
      }
    }
    return null;
  }

  Future<QRCode> getQrCode(int stationId) async {
    Map<String, String> body = {'stationId': stationId.toString()};
    print(body);
    http.Response response = await http.post(
      'http://10.0.2.2:8082/v1/qrcode',
      body: body,
    );
    if (response.statusCode == 200) {
      var decodedJson = json.decode(response.body);
      QRCode ret = QRCode(
          id: decodedJson["id"],
          isActive: decodedJson["isActive"],
          offerDescription: decodedJson["voucherDesc"],
          offerName: decodedJson["voucherName"]);
      return ret;
    }
    return null;
  }

  Future<int> getQrCodeStatus(int qrCodeId) async {
    int ret;
    http.Response response =
        await http.get("http://10.0.2.2:8082/v1/qrcode/${qrCodeId}");
    if (response.statusCode == 200) {
      var decodedJson = json.decode(response.body);
      ret = decodedJson["qrCodeStatus"];
      return ret;
    }
    return ret;
  }
}
