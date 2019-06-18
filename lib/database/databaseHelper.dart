import 'dart:io';

import 'package:kaufland_qr/models/qrcode.dart';
import 'package:path/path.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "IoTKaufland2.db";
  static final _databaseVersion = 3;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE `qrcodes` (
              `id`	INTEGER PRIMARY KEY,
              `offerName`	TEXT,
              `offerDescription`	TEXT,
              `isActive`	INTEGER              
              );
              ''');
  }

  // Database helper methods:

  Future<int> insertQrCode(QRCode qrCode) async {
    Database db = await database;
    int id = await db.insert("qrcodes", qrCode.toMap());
    return id;
  }

  Future<bool> deleteQrCode(int id) async {
    Database db = await database;
    var test = await db.delete("qrcodes", where: "id=?", whereArgs: [id]);
    print(test);
    return true;
  }

  Future<List<QRCode>> getQRCodesByStatus(int status) async {
    Database db = await database;
    List<Map> maps =
        await db.query("qrcodes", where: "isActive = ?", whereArgs: [status]);
    List<QRCode> _ret = [];
    if (maps.length > 0) {
      for (Map<String, dynamic> map in maps) {
        _ret.add(QRCode.fromMap(map));
      }
    }
    return _ret;
  }
}
