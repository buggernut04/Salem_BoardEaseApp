import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../classes/tenant.dart';

class DatabaseHelper {

  DatabaseHelper._createInstance();
  static DatabaseHelper databaseHelper = DatabaseHelper._createInstance(); // Singleton DatabaseHelper
  static Database? _database; // Singleton Database

  // tenants information
  String tenantTable = 'tenant_table';
  String colId = 'id';
  String colName = 'name';
  String colContactInfo = 'contactInfo';
  String colStartDate = 'startDate';
  String colCurrentDate = 'currentDate';
  String colStatus = 'status';

  // tenants payment
  String tenantPaymentTable = 'tenantPayment_table';
  String colTPaymentId = 'id';
  String colTPaymentName = 'paymentName';
  String colTPaymentAmount = "amount";
  String colTPaymentIsPayed = "isPayed";

  // owners payment
  String ownerPaymentTable = 'ownerPayment_table';
  String colWPaymentId = 'id';
  String colWPaymentName = 'paymentName';
  String colWPaymentAmount = "amount";
  String colWPaymentDatePayed = "datePayed";


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
    await db.execute('CREATE TABLE $tenantTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colContactInfo TEXT, $colStartDate TEXT, $colCurrentDate TEXT, $colStatus INTEGER)');

    await db.execute('CREATE TABLE $tenantPaymentTable($colTPaymentId INTEGER PRIMARY KEY AUTOINCREMENT, $colTPaymentName TEXT, $colTPaymentAmount INTEGER, $colTPaymentIsPayed INTEGER)');

    await db.execute('CREATE TABLE $ownerPaymentTable($colWPaymentId INTEGER PRIMARY KEY AUTOINCREMENT, $colWPaymentName TEXT, $colWPaymentAmount INTEGER, $colWPaymentDatePayed TEXT)');
  }

  // TENANT INFORMATION SECTION
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

  // Fetch Operation: Get all tenant objects from the database
  Future<List<Tenant>> getTenantList() async{
    Database? db = await databaseHelper.database;
    var tenant = await db?.query(tenantTable, orderBy: colCurrentDate);

    List<Tenant>? tenantList = tenant != null ? tenant.map((e) => Tenant.fromMapObject(e)).toList() : [];

    return tenantList;
  }

  // Fetch Operation: Get all payed tenant objects from the database
  Future<List<Tenant>> getPayedTenantList() async{
    Database? db = await databaseHelper.database;

    var tenant = await db?.query(tenantTable, orderBy: colCurrentDate, where: '$colStatus = 1');

    List<Tenant>? tenantList = tenant != null ? tenant.map((e) => Tenant.fromMapObject(e)).toList() : [];

    return tenantList;
  }

  // Get number of all tenants in the database
  Future<int?> getAllTenantNum() async{
    Database? db = await databaseHelper.database;

    List<Map<String, dynamic>>? x = await db?.rawQuery('SELECT COUNT (*) from $tenantTable');
    
    int? result = Sqflite.firstIntValue(x!);
    return result;
  }

  // Get number of all tenants that already payed
  Future<int?> getPayedTenantNum() async{
    Database? db = await databaseHelper.database;

    List<Map<String, dynamic>>? x = await db?.rawQuery('SELECT COUNT (*) from $tenantTable where $colStatus = 1');

    int? result = Sqflite.firstIntValue(x!);
    return result;
  }

  // Get number of all tenants that are not fully payed
  Future<int?> getNotFullyPayedTenantNum() async{
    Database? db = await databaseHelper.database;

    List<Map<String, dynamic>>? x = await db?.rawQuery('SELECT COUNT (*) from $tenantTable where $colStatus = 2');

    int? result = Sqflite.firstIntValue(x!);
    return result;
  }

  // Get number of all tenants that not yet payed
  Future<int?> getNotPayedTenantNum() async{
    Database? db = await databaseHelper.database;

    List<Map<String, dynamic>>? x = await db?.rawQuery('SELECT COUNT (*) from $tenantTable where $colStatus = 3');

    int? result = Sqflite.firstIntValue(x!);
    return result;
  }

  // TENANT PAYMENT SECTION



  // OWNER PAYMENT SECTION

  // to be deleted functions
  void deleteTable() async {
    Database? db = await databaseHelper.database;

    await db?.execute('DROP TABLE IF EXISTS $tenantTable');
  }

  void createTable() async{
    Database? db = await databaseHelper.database;

    await db?.execute('CREATE TABLE $tenantTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colContactInfo TEXT, $colStartDate TEXT,$colCurrentDate TEXT, $colStatus INTEGER)');
  }
}