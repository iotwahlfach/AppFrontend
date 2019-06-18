import 'package:flutter/material.dart';
import 'package:kaufland_qr/pages/homePage.dart';
import 'package:kaufland_qr/pages/wrapperPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static Map<int, Color> color = {
    50: Color.fromRGBO(255, 9, 21, 0.1),
    100: Color.fromRGBO(255, 9, 21, 0.2),
    200: Color.fromRGBO(255, 9, 21, 0.3),
    300: Color.fromRGBO(255, 9, 21, 0.4),
    400: Color.fromRGBO(255, 9, 21, 0.5),
    500: Color.fromRGBO(255, 9, 21, 0.6),
    600: Color.fromRGBO(255, 9, 21, 0.7),
    700: Color.fromRGBO(255, 9, 21, 0.8),
    800: Color.fromRGBO(255, 9, 21, 0.9),
    900: Color.fromRGBO(255, 9, 21, 1)
  };
  MaterialColor costumColor = MaterialColor(0xFFE10915, color);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaufland Einkaufwagen',
      theme: ThemeData(
        primarySwatch: costumColor,
        buttonColor: costumColor,
      ),
      home: WrapperPage(),
    );
  }
}
