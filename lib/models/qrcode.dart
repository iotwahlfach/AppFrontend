class QRCode {
  int id;
  String offerName;
  String offerDescription;
  int isActive;

  QRCode({this.id, this.offerName, this.offerDescription, this.isActive});

  QRCode.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    offerName = map["offerName"];
    offerDescription = map["offerDescription"];
    isActive = map["isActive"];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'offerName': this.offerName,
      'offerDescription': this.offerDescription,
      'isActive': this.isActive,
    };

    if (id != null) {
      map["id"] = id;
    }
    return map;
  }
}
