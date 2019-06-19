import 'dart:convert';

class Station {
  int id;
  String name;

  Station({this.id, this.name});

  @override
  String toString() {
    Map<String, dynamic> retMap = {
      "id": id,
      "name": name,
    };
    print(retMap.toString());
    return retMap.toString();
  }

  Station.fromString(String stationString) {
    var decodedJson = jsonDecode(stationString);
    Station ret = Station(id: decodedJson["id"], name: decodedJson["name"]);
  }
}
