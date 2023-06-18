import 'dart:async';

import 'package:boardease_application/classes/model/tenantlist.dart';
import 'package:boardease_application/inputDetails/tenant_status.dart';
import 'package:boardease_application/classes/model/tenant.dart';
import 'package:boardease_application/database/databasehelper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../inputDetails/tenant_detail.dart';
import '../notification_service/notification_body.dart';

class TenantRecord extends StatefulWidget {
  const TenantRecord({Key? key}) : super(key: key);

  @override
  State<TenantRecord> createState() => _TenantRecordState();
}

class _TenantRecordState extends State<TenantRecord> {

  TenantList tenantList = TenantList(tenant: []);

  void updateListView(){
    final Future<Database> dbFuture = DatabaseHelper.databaseHelper.initializeDatabase();

    dbFuture.then((database){
      Future<List<Tenant>> tenantListFuture = DatabaseHelper.databaseHelper.getTenantList();
      tenantListFuture.then((tenants){
        if(mounted) {
          setState(() {
            tenantList.tenant = tenants;
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
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 20.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    const Text(
                      'Records',
                      style: TextStyle(
                        fontSize: 23.0,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),

                    Row(
                      children: <Widget>[

                        IconButton(
                          onPressed: (){},
                          icon: const Icon(Icons.sort),
                        ),

                        IconButton(
                          onPressed: (){},
                          icon: const Icon(Icons.search),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
              
              tenantList.tenant.isEmpty
                  ? Center(
                child: Text(
                  'No tenant records',
                  style: TextStyle(fontSize: 18.0, color: Colors.grey[600], fontStyle: FontStyle.italic),
                ),
              ) : Expanded(
                child: ListView.builder(
                        itemCount: tenantList.tenant.length,
                        itemBuilder: (BuildContext context, int position){
                          return Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Card(
                                  color: Colors.white,
                                  margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0,1.0),
                                  elevation: 2.0,
                                  child: ListTile(
                                    onTap: () {
                                      routeToTenantStatus(tenantList.tenant[position]);
                                    },
                                    leading: CircleAvatar(
                                      backgroundColor: tenantList.tenant[position].getStatusColor(),
                                      child: const Icon(Icons.perm_identity_rounded),
                                    ),
                                    title: Text(
                                        tenantList.tenant[position].name.toString(),
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.grey[600],
                                        )
                                    ),
                                    subtitle: Text(
                                        tenantList.tenant[position].getStatus(),
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
                                            routeToTenantDetail(tenantList.tenant[position], 'Edit Tenant');
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () async {
                                            tenantList.tenant[position].removeTenant(context);

                                            cancelAllNotifications();

                                            if(tenantList.tenant.isNotEmpty){
                                              tenantList.getTenantForNotification();
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
            ],
          ),
        ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                routeToTenantDetail(Tenant(name: '', contactInfo: '', status: 3, startDate: DateTime.now(), currentDate: DateTime.now(), tenantPayment: []), 'Add Tenant');},
              backgroundColor: Colors.white60,
              child: const Icon(
                Icons.person_add,
                color: Colors.blueAccent,
                size: 30,
              ),
            ),
        );
    }
}
