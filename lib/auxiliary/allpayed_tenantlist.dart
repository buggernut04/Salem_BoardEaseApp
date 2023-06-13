import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/model/tenant.dart';
import '../database/databasehelper.dart';

class AllPayedTenants extends StatefulWidget {
  const AllPayedTenants({Key? key}) : super(key: key);

  @override
  State<AllPayedTenants> createState() => _AllPayedTenantsState();
}

class _AllPayedTenantsState extends State<AllPayedTenants> {

  List<Tenant> tenants = [];
  int count = 0;

  void updateListView() {
    final Future<Database> dbFuture = DatabaseHelper.databaseHelper
        .initializeDatabase();

    dbFuture.then((database) {
      Future<List<Tenant>> tenantListFuture = DatabaseHelper.databaseHelper
          .getPayedTenantList();
      tenantListFuture.then((tenants) {
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
  void initState(){
    super.initState();
    updateListView();
  }

  @override
  Widget build(BuildContext context) {

    updateListView();

    return Expanded(
      child: ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position){
        return Padding(
            padding: const EdgeInsets.all(1.0),
            child: Card(
                color: Colors.white70,
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0,1.0),
                elevation: 2.0,
                child: ListTile(
                  onTap: () {},
                  leading: const CircleAvatar(
                    backgroundColor: Colors.greenAccent,
                    child: Icon(Icons.perm_identity_rounded),
                  ),
                  title: Text(
                      tenants[position].name.toString(),
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
                      'See Info',
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
    );
  }
}
