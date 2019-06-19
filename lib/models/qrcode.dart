import 'package:kaufland_qr/models/station.dart';

class QRCode {
  int id;
  String offerName;
  String offerDescription;
  Station station;
  int isActive;

  QRCode(
      {this.id,
      this.offerName,
      this.offerDescription,
      this.isActive,
      this.station});

  QRCode.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    offerName = map["offerName"];
    offerDescription = map["offerDescription"];
    isActive = map["isActive"];
    station = Station(id: map["stationId"], name: map["stationName"]);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'offerName': this.offerName,
      'offerDescription': this.offerDescription,
      'isActive': this.isActive,
    };
    if (station != null) {
      map["stationId"] = station.id;
      map["stationName"] = station.name;
    }
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }
}
