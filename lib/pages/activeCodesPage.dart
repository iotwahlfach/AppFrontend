import 'package:flutter/material.dart';
import 'package:kaufland_qr/database/databaseHelper.dart';
import 'package:kaufland_qr/models/qrcode.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ActiveCodesPage extends StatefulWidget {
  _ActiveCodesPageState createState() => _ActiveCodesPageState();
}

class _ActiveCodesPageState extends State<ActiveCodesPage> {
  List<QRCode> _qrCodeList = [];

  void loadData() {
    DatabaseHelper.instance.getQRCodesByStatus(1).then((qrCodeLists) {
      setState(() {
        _qrCodeList = qrCodeLists;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: _getPageContent(),
    );
  }

  Widget _getPageContent() {
    Widget _ret = Container();
    if (_qrCodeList.isEmpty) {
      _ret = Text("Sie haben keine activen QR Codes.");
      return _ret;
    } else {
      _ret = Column(
        children: <Widget>[
          RaisedButton(
            child: Text("Reload"),
            onPressed: () {
              print("Pressed");
              loadData();
            },
          ),
          ListView(
            children: _qrCodeListTiles(),
          ),
        ],
      );
    }
    return _ret;
  }

  List<Widget> _qrCodeListTiles() {
    List<Widget> _ret = [];
    for (QRCode qrCode in _qrCodeList) {
      ListTile temp = ListTile(
        leading: Icon(Icons.fullscreen),
        title: Text(qrCode.offerName),
        subtitle: Text(qrCode.offerDescription),
        onTap: () {
          _showDialog(qrCode);
        },
      );
      _ret.add(temp);
    }
    return _ret;
  }

  void _showDialog(QRCode qrCode) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Dein Coupon Code"),
            children: <Widget>[
              Container(
                width: 300.0,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    QrImage(
                      data: "${qrCode.id}",
                      size: 200.0,
                    ),
                    RaisedButton(
                      child: Text(
                        "Abbrechen",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }
}
