import 'dart:async';

import 'package:boardease_application/classes/tenant.dart';
import 'package:boardease_application/database/databasehelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../auxiliary/tenant_detail.dart';

class TenantList extends StatefulWidget {
  const TenantList({Key? key}) : super(key: key);

  @override
  State<TenantList> createState() => _TenantListState();
}

class _TenantListState extends State<TenantList> {

  List<Tenant> tenants = [];
  int count = 0;

  void route(Tenant tenant, String title) async {
   bool result =  await Navigator.push(
       context,
        MaterialPageRoute(builder: (context) {
          return TenantDetail( appBarTitle: title, tenant: tenant);
        })
    );
   if(result){
     updateListView();
   }
  }

  String getStatus(int? status){
    if(status == 1){
      return 'Payed';
    }
    else if(status == 2){
      return 'Not Fully Payed';
    }
    else{
      return 'Not Payed';
    }
  }

  // every status has its own color
  Color getStatusColor(int? status){
    if(status == 1){
      return Colors.yellow;
    }
    else if(status == 2){
      return Colors.greenAccent;
    }
    else{
      return Colors.red;
    } 
  }

  void updateListView(){
    final Future<Database> dbFuture = DatabaseHelper.databaseHelper.initializeDatabase();

    dbFuture.then((database){
      Future<List<Tenant>> tenantListFuture = DatabaseHelper.databaseHelper.getTenantList();
      tenantListFuture.then((tenants){
        if(mounted) {
          setState(() {
            this.tenants = tenants;
            count = tenants.length;
          });
        }
      });
    });
  }

  String dateInfo(DateTime dt) => DateFormat('MMMM d, y').format(dt);

  @override
  Widget build(BuildContext context) {

    updateListView();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('All Tenants'),
          backgroundColor: Colors.blue[300],
        ),
        body: ListView.builder(
                itemCount: count,
                itemBuilder: (BuildContext context, int position){
                  return Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Card(
                          color: Colors.white,
                          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0,1.0),
                          elevation: 2.0,
                          child: ListTile(
                            onTap: () {
                              route(this.tenants[position], 'Edit Tenant');
                            },
                            leading: CircleAvatar(
                              backgroundColor: getStatusColor(this.tenants[position].status),
                              child: Icon(Icons.perm_identity_rounded),
                            ),
                            title: Text(
                                this.tenants[position].name.toString(),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey[600],
                                )
                            ),
                            subtitle: Text(
                                dateInfo(tenants[position].currentDate),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey[600],
                                )
                            ),
                            trailing:Text(
                              getStatus(this.tenants[position].status),
                              style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey[600],
                               )
                            ),
                          )
                      )
                  );
                }
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  route(Tenant(name: '', contactInfo: '', status: 3, startDate: DateTime.now(), currentDate: DateTime.now()), 'Add Tenant');
                },
              backgroundColor: Colors.blueAccent,
              child: const Icon(
                Icons.person_add,
                size: 30,
              ),
            )
    );
  }
}
