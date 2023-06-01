import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../classes/tenant.dart';

class DatabaseHelper {

  DatabaseHelper._createInstance();
  static DatabaseHelper databaseHelper = DatabaseHelper._createInstance(); // Singleton DatabaseHelper
  static Database? _database; // Singleton Datebase

  String tenantTable = 'tenant_table';
  String colId = 'id';
  String colName = 'name';
  String colContactInfo = 'contactInfo';
  String colStartDate = 'startDate';
  String colStatus = 'status';

  Future<Database?> get database async{
    if(_database != null){
      return _database;
    }

    _database = await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async{
    // Get the directory path
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'boardEase.db');

    // Open/create the database at a given path
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $tenantTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colContactInfo TEXT, $colStartDate TEXT, $colStatus INTEGER)');
  }

  // Fetch Operation: Get all note objects from the database
  Future<List<Tenant>> getTenantList() async{
    Database? db = await databaseHelper.database;
    var tenant = await db?.query(tenantTable, orderBy: colStatus);

    List<Tenant>? tenantList = tenant != null ? tenant.map((e) => Tenant.fromMapObject(e)).toList() : [];

    return tenantList;
  }


  //Insert Operation: Insert a Tenant object to the database
  Future<int?> insertTenant(Tenant tenant) async{
    Database? db = await databaseHelper.database;

    var result = await db?.insert(tenantTable, tenant.toMap());

    return result;
  }

  //Update Operation: Update a Tenant object to the database
  Future<int?> updateTenant(Tenant tenant) async{
    Database? db = await databaseHelper.database;

    var result = await db?.update(tenantTable, tenant.toMap(), where: '$colId = ?', whereArgs: [tenant.id]);

    return result;
  }

  //Delete Operation: Delete a Tenant object to the database
  Future<int?> deleteTenant(int? id) async{
    Database? db = await databaseHelper.database;

    int? result = await db?.delete(tenantTable, where: '$colId = $id');

    return result;
  }

  // Get number of all tenants in the database
  Future<int?> getTenantCount() async{
    Database? db = await databaseHelper.database;

    List<Map<String, dynamic>>? x = await db?.rawQuery('SELECT COUNT (*) from $tenantTable');
    
    int? result = Sqflite.firstIntValue(x!);
    return result;
  }

}