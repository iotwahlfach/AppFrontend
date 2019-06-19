import 'dart:convert';
import 'dart:math';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:kaufland_qr/database/databaseHelper.dart';
import 'package:kaufland_qr/database/utils.dart';
import 'package:kaufland_qr/models/qrcode.dart';
import 'package:kaufland_qr/models/station.dart';
import 'package:kaufland_qr/utils/reqHelper.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  HomePage() {}

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var initAndroid = AndroidInitializationSettings("kaufland_logo");
    var initIos = IOSInitializationSettings();
    var initSett = InitializationSettings(initAndroid, initIos);
    flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationPlugin.initialize(initSett,
        onSelectNotification: _notificationSelected);
  }

  Future _notificationSelected(String stationString) async {
    ReqHelper reqHelper = ReqHelper();
    //Map<String, dynamic> map = await jsonDecode(stationString);
    var stringArray = stationString.split(",");
    print(stringArray[0]);
    Station station =
        Station(id: int.parse(stringArray[1]), name: stringArray[0]);

    _showDialog(station);
  }

  Future _showNotificationQR(Station station) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channel_id', 'QR Code Channel', 'QR Code description',
        playSound: false, importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationPlugin.show(
      0,
      'Einkaufswagen Coupon an Station ${station.id}',
      'Hohlen Sie sich ihren Coupon ab. Klicken Sie hier!',
      platformChannelSpecifics,
      payload: "${station.name},${station.id.toString()}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/kaufland_logo.jpg",
            height: 200.0,
          ),
          Text(
            "Willkommen bei der IoT Kaufland App",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          RaisedButton(
            child: Text(
              "Send notification",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              //Get action
              //Get qr code informations
              ReqHelper reqHelper = ReqHelper();
              reqHelper.getUsedAction().then((result) => {
                    if (result != null)
                      {
                        _showNotificationQR(
                          result,
                        )
                      }
                  });

              print("Button pressed");
            },
          )
        ],
      ),
    );
  }

  void _showDialog(Station station) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Einkaufscoupon"),
            children: <Widget>[
              Container(
                width: 300.0,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Text(
                        "Lieber Kunde, leider kommt es aktuell zu einem erhöhten Füllstand von Einkaufswagen bei Station ${station.name} mit der Nummer ${station.id}. Helfen Sie uns und holen Sie den Einkaufswagen an der Station ab. Sie bekommen einen QR Code den Sie an der Station aktivieren können."),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            "Abbrechen",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        RaisedButton(
                          child: Text(
                            "Annehmen",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Utils util = Utils();
                            ReqHelper reqHelper = ReqHelper();
                            QRCode qrCode;
                            reqHelper.getQrCode(station.id).then((QRCode data) {
                              qrCode = data;
                              qrCode.station = station;
                              print(qrCode);
                              util.insertPendingQRCode(qrCode).then((id) {
                                print("ID:" + id.toString());

                                Toast.show(
                                    "QR Code als Pending hinzugefügt", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                                Navigator.of(context).pop();
                              });
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }
}
