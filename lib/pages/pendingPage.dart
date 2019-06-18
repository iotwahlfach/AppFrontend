import 'package:flutter/material.dart';
import 'package:kaufland_qr/database/databaseHelper.dart';
import 'package:kaufland_qr/models/qrcode.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
                "Ihr QR Code ist noch nicht aktiviert. Bitte aktivieren Sie ihren QR Code an Station 5"),
          ),
          SizedBox(
            height: 20,
          ),
          QrImage(
            data: _qrCode.id.toString(),
            size: 200.0,
          ),
        ],
      );
    }
    return ret;
  }
}
