import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kaufland_qr/database/databaseHelper.dart';
import 'package:kaufland_qr/database/utils.dart';
import 'package:kaufland_qr/models/qrcode.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  HomePage();

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

  Future _notificationSelected(String playload) async {
    QRCode qrCode = QRCode(
        id: 1224,
        isActive: 0,
        offerDescription: "Du bekommst cooles Fleisch",
        offerName: "Hammersache");
    _showDialog(qrCode);
  }

  Future _showNotificationQR() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channel_id', 'QR Code Channel', 'QR Code description',
        playSound: false, importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationPlugin.show(
      0,
      'Einkaufswagen Coupong',
      'Hohlen Sie sich ihren Coupon ab. Klicken Sie hier!',
      platformChannelSpecifics,
      payload: 'No_Sound',
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

              _showNotificationQR();
              print("Button pressed");
            },
          )
        ],
      ),
    );
  }

  void _showDialog(QRCode qrCode) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Your QR Code"),
            children: <Widget>[
              Container(
                width: 300.0,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Text(
                        "Hier ist ihr QR Code. Scannen sie ihn einfach ab und aktivieren sie ihn"),
                    QrImage(
                      data: "Das ist text data",
                      size: 200.0,
                    ),
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
                            util.insertPendingQRCode(qrCode).then((id) {
                              print("ID:" + id.toString());
                              Navigator.of(context).pop();
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
