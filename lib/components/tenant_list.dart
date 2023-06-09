import 'dart:async';

import 'package:boardease_application/auxiliary/tenant_status.dart';
import 'package:boardease_application/classes/model/tenant.dart';
import 'package:boardease_application/database/databasehelper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../inputDetails/tenant_detail.dart';

class TenantList extends StatefulWidget {
  const TenantList({Key? key}) : super(key: key);

  @override
  State<TenantList> createState() => _TenantListState();
}

class _TenantListState extends State<TenantList> {

  List<Tenant> tenants = [];
  int count = 0;

  void routeToAddDelete(Tenant tenant, String title) async {
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

  void routeToTPayment(Tenant tenant) async {
    bool result =  await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return TenantStatus(tenant: tenant);
        })
    );
    if(result){
      updateListView();
    }
  }

  void removeTenant(BuildContext context, Tenant tenant) async {
    int? result = await DatabaseHelper.databaseHelper.deleteTenant(tenant.id);

    if(result != 0){
      showSnackBar(context, 'Tenant Removed');
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

  @override
  Widget build(BuildContext context) {

    updateListView();

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text('Tenants List'),
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
                              routeToTPayment(tenants[position]);
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
                                getStatus(tenants[position].status),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey[600],
                                )
                            ),
                            trailing:Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    routeToAddDelete(tenants[position], 'Edit Tenant');
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    removeTenant(context, tenants[position]);
                                  },
                                ),
                              ],
                            ),
                          )
                      )
                  );
                }
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  routeToAddDelete(Tenant(name: '', contactInfo: '', status: 3, startDate: DateTime.now(), currentDate: DateTime.now()), 'Add Tenant');
                },
              backgroundColor: Colors.blueAccent,
              child: const Icon(
                Icons.person_add,
                size: 30,
              ),
            )
        );
    }

  void showSnackBar(BuildContext context, String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
}
