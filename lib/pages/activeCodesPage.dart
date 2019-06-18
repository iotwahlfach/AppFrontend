import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ActiveCodesPage extends StatefulWidget {
  _ActiveCodesPageState createState() => _ActiveCodesPageState();
}

class _ActiveCodesPageState extends State<ActiveCodesPage> {
  List<String> qrCodeStringList = ["QRCode1", "QrCode2"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: _getPageContent(),
    );
  }

  Widget _getPageContent() {
    Widget _ret = Container();
    if (qrCodeStringList.isEmpty) {
      _ret = Text("Sie haben keine activen QR Codes.");
      return _ret;
    } else {
      _ret = ListView(
        children: _qrCodeListTiles(),
      );
    }
    return _ret;
  }

  List<Widget> _qrCodeListTiles() {
    List<Widget> _ret = [];
    for (String qrCode in qrCodeStringList) {
      ListTile temp = ListTile(
        leading: Icon(Icons.fullscreen),
        title: Text("Testtitle"),
        subtitle: Text("Subttle"),
        onTap: () {
          _showDialog("Testdata");
        },
      );
      _ret.add(temp);
    }
    return _ret;
  }

  void _showDialog(String _qrCode) {
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
                      data: "Das ist text data",
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
