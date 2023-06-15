import 'dart:async';

import 'package:boardease_application/inputDetails/tenant_status.dart';
import 'package:boardease_application/classes/model/tenant.dart';
import 'package:boardease_application/database/databasehelper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../inputDetails/tenant_detail.dart';
import '../notification_service/notification_body.dart';

class TenantList extends StatefulWidget {
  const TenantList({Key? key}) : super(key: key);

  @override
  State<TenantList> createState() => _TenantListState();
}

class _TenantListState extends State<TenantList> {

  List<Tenant> tenants = [];

  void updateListView(){
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

  void routeToTenantDetail(Tenant tenant, String title) async {
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

  void routeToTenantStatus(Tenant tenant) async {
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

  void getTenantForNotification(List<Tenant> tenants){
    /*Tenant tenantWithNearestDate = tenant.reduce((a, b) =>
    (DateTime.parse(a.currentDate.toString()).difference(DateTime.now()).abs() <
        DateTime.parse(b.currentDate.toString()).difference(DateTime.now()).abs())
        ? a
        : b);*/

    List<Tenant> filteredTenants = tenants
        .where((tenant) => tenant.status != 1)
        .toList();

    if (filteredTenants.isEmpty) {
      return;
    }

    DateTime now = DateTime.now();
    Tenant tenantWithNearestDate = filteredTenants.reduce((a, b) =>
    (a.currentDate.difference(now).abs() <
        b.currentDate.difference(now).abs())
        ? a
        : b);

    debugPrint("${tenantWithNearestDate.currentDate.month} + ${tenantWithNearestDate.currentDate.day - 3} + ${tenantWithNearestDate.name}");

    getTenantNotificationWhenAlmostDue(tenantWithNearestDate);
    getTenantNotificationWhenDue(tenantWithNearestDate);
  }


  @override
  Widget build(BuildContext context) {

    updateListView();

    return Scaffold(
        backgroundColor: Colors.blue[300],
        appBar: AppBar(
          title: const Text(
            'BoardEase',
            style: TextStyle(
              fontSize: 25,
              color: Colors.black54,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[300],
          elevation: 1.0,
        ),
        body: Container(
          height: 800,
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )
          ),
          child: tenants.isEmpty
              ? Center(
            child: Text(
              'No tenant records',
              style: TextStyle(fontSize: 18.0, color: Colors.grey[600], fontStyle: FontStyle.italic),
            ),
          ) : ListView.builder(
                  itemCount: tenants.length,
                  itemBuilder: (BuildContext context, int position){
                    return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Card(
                            color: Colors.white,
                            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0,1.0),
                            elevation: 2.0,
                            child: ListTile(
                              onTap: () {
                                routeToTenantStatus(tenants[position]);
                              },
                              leading: CircleAvatar(
                                backgroundColor: getStatusColor(tenants[position].status),
                                child: const Icon(Icons.perm_identity_rounded),
                              ),
                              title: Text(
                                  tenants[position].name.toString(),
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
                                      routeToTenantDetail(tenants[position], 'Edit Tenant');
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      tenants[position].removeTenant(context);

                                      cancelAllNotifications();

                                      if(tenants.isNotEmpty){
                                        getTenantForNotification(tenants);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              dense: true,
                            )
                        )
                    );
                  }
              ),
        ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  routeToTenantDetail(Tenant(name: '', contactInfo: '', status: 3, startDate: DateTime.now(), currentDate: DateTime.now(), tenantPayment: []), 'Add Tenant');
                },
              backgroundColor: Colors.blueAccent,
              child: const Icon(
                Icons.person_add,
                size: 30,
              ),
            )
        );
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
