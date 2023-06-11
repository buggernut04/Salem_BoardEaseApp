import 'package:boardease_application/classes/model/ownerpayment.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../classes/model/tenant.dart';
import '../classes/model/tenantpayment.dart';

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
  String colTenantPayment = 'tenantPayment';

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
    await db.execute('CREATE TABLE $tenantTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colContactInfo TEXT, $colStartDate TEXT, $colCurrentDate TEXT, $colStatus INTEGER, $colTenantPayment BLOB)');

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

  // TENANT PAYMENT SECTION
  Future<int?> insertTPayment(TenantPayment tPayment) async{
    Database? db = await databaseHelper.database;

    var result = await db?.insert(tenantPaymentTable, tPayment.toMap());

    return result;
  }

  Future<int?> updateTPayment(TenantPayment tPayment) async{
    Database? db = await databaseHelper.database;

    var result = await db?.update(tenantPaymentTable, tPayment.toMap(), where: '$colId = ?', whereArgs: [tPayment.id]);

    return result;
  }

  Future<int?> deleteTPayment(int? id) async{
    Database? db = await databaseHelper.database;

    int? result = await db?.delete(tenantPaymentTable, where: '$colId = $id');

    return result;
  }

  Future<List<TenantPayment>> getTPaymentList() async{
    Database? db = await databaseHelper.database;
    var tPayment = await db?.query(tenantPaymentTable);

    List<TenantPayment>? tPaymentList = tPayment != null ? tPayment.map((e) => TenantPayment.fromMapObject(e)).toList() : [];

    return tPaymentList;
  }

  // OWNER PAYMENT SECTION
  Future<int?> insertWPayment(OwnerPayment wPayment) async{
    Database? db = await databaseHelper.database;

    var result = await db?.insert(ownerPaymentTable, wPayment.toMap());

    return result;
  }

  Future<int?> updateWPayment(OwnerPayment wPayment) async{
    Database? db = await databaseHelper.database;

    var result = await db?.update(ownerPaymentTable, wPayment.toMap(), where: '$colId = ?', whereArgs: [wPayment.id]);

    return result;
  }

  Future<int?> deleteWPayment(int? id) async{
    Database? db = await databaseHelper.database;

    int? result = await db?.delete(ownerPaymentTable, where: '$colId = $id');

    return result;
  }

  Future<List<OwnerPayment>> getWPaymentList() async{
    Database? db = await databaseHelper.database;
    var wPayment = await db?.query(ownerPaymentTable);

    List<OwnerPayment>? wPaymentList = wPayment != null ? wPayment.map((e) => OwnerPayment.fromMapObject(e)).toList() : [];

    return wPaymentList;
  }

  // to be deleted functions

  void deleteTable() async {
    Database? db = await databaseHelper.database;

    await db?.execute('DROP TABLE IF EXISTS $tenantTable');
    await db?.execute('DROP TABLE IF EXISTS $tenantPaymentTable');
    //await db?.execute('DROP TABLE IF EXISTS $ownerPaymentTable');
  }

  void createTable() async{
    Database? db = await databaseHelper.database;

    await db?.execute('CREATE TABLE $tenantTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colContactInfo TEXT, $colStartDate TEXT, $colCurrentDate TEXT, $colStatus INTEGER, $colTenantPayment BLOB)');

    await db?.execute('CREATE TABLE $tenantPaymentTable($colTPaymentId INTEGER PRIMARY KEY AUTOINCREMENT, $colTPaymentName TEXT, $colTPaymentAmount INTEGER, $colTPaymentIsPayed INTEGER)');

    //await db?.execute('CREATE TABLE $ownerPaymentTable($colWPaymentId INTEGER PRIMARY KEY AUTOINCREMENT, $colWPaymentName TEXT, $colWPaymentAmount INTEGER, $colWPaymentDatePayed TEXT)');
  }
}