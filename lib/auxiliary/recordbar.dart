import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/model/tenant.dart';
import '../database/databasehelper.dart';


class RecordBar extends StatefulWidget {
  const RecordBar({Key? key}) : super(key: key);

  @override
  State<RecordBar> createState() => _RecordBarState();
}

class _RecordBarState extends State<RecordBar> {

  List<Tenant> tenants = [];

  void getAllTenants(){
    final Future<Database> dbFuture = DatabaseHelper.databaseHelper.initializeDatabase();

    dbFuture.then((database){
      Future<List<Tenant>> tenantListFuture = DatabaseHelper.databaseHelper.getTenantList();
      tenantListFuture.then((tenants){
        if(mounted) {
          setState(() {
            this.tenants = tenants;
          });
        }
      });
    });
  }

  int _fetchPayedTenantCount() {
    return tenants.where((tenant) => tenant.status == 1).length;
  }

  @override
  void initState() {
    super.initState();
    getAllTenants();
  }


  @override
  Widget build(BuildContext context) {

    return CircularPercentIndicator(
      radius: 180.0,
      lineWidth: 25.0,
      percent: tenants.isEmpty ? 0.0 : _fetchPayedTenantCount() / tenants.length,
      center: Text('${_fetchPayedTenantCount()} / ${tenants.length} \n Paid Tenants',textAlign: TextAlign.center, style: const TextStyle(fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),),
      animation: true,
      animationDuration: 1500,
      progressColor: Colors.indigo,
    );
  }
}