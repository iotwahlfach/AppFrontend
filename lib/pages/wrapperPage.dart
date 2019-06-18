import 'package:flutter/material.dart';
import 'package:kaufland_qr/pages/activeCodesPage.dart';
import 'package:kaufland_qr/pages/homePage.dart';
import 'package:kaufland_qr/pages/pendingPage.dart';

class WrapperPage extends StatefulWidget {
  _WrapperPageState createState() => _WrapperPageState();
}

class _WrapperPageState extends State<WrapperPage> {
  String appBarTitle = "Home page";
  int _currentIndex = 0;
  final List<Widget> _pages = [HomePage(), PendingPage(), ActiveCodesPage()];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.autorenew),
            title: Text("Pending Codes"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text("My QR Codes"),
          )
        ],
      ),
    );
  }
}
