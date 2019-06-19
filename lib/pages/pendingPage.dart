import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kaufland_qr/database/databaseHelper.dart';
import 'package:kaufland_qr/models/qrcode.dart';
import 'package:kaufland_qr/utils/reqHelper.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:toast/toast.dart';

class PendingPage extends StatefulWidget {
  @override
  _PendingPageState createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  QRCode _qrCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(15),
      child: _pageContent(),
    );
  }

  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.getQRCodesByStatus(0).then((list) {
      setState(() {
        if (list.isEmpty)
          _qrCode = null;
        else
          _qrCode = list.first;
      });
    });
    ReqHelper reqHelper = ReqHelper();
    const intervall = const Duration(seconds: 5);
    new Timer.periodic(intervall, (Timer t) {
      if (_qrCode != null) {
        print("Timeclock");
        reqHelper.getQrCodeStatus(_qrCode.id).then((status) {
          print(status);
          if (status == 0) {
            return;
          } else {
            Toast.show("QR Code aktiviert", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            _qrCode.isActive = 1;
            DatabaseHelper.instance.enableQrCode(_qrCode);
            t.cancel();
            setState(() {
              _qrCode = null;
            });
          }
        });
      }
    });
  }

  Widget _pageContent() {
    Widget ret = Container();
    if (_qrCode == null) {
      ret = Text("Sie haben keine QR Codes zu aktivieren.");
      return ret;
    } else {
      ret = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
                "Ihr QR Code ist noch nicht aktiviert. Bitte aktivieren Sie ihren QR Code an Station ${_qrCode.station.name}"),
          ),
          SizedBox(
            height: 20,
          ),
          QrImage(
            data: _qrCode.id.toString(),
            size: 200.0,
            version: 1,
          ),
        ],
      );
    }
    return ret;
  }
}
