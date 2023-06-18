import 'package:boardease_application/auxiliary/filtered_tenantlist.dart';
import 'package:boardease_application/classes/model/tenantlist.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
//import '../auxiliary/dotindicator.dart';
import '../auxiliary/dotindicator.dart';
import '../auxiliary/homeview.dart';
import '../classes/model/tenant.dart';
import '../database/databasehelper.dart';

class MyHomePage extends StatefulWidget    {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TenantList tenantsList = TenantList(tenant: []);
  int currentIndex = 0;

  void getAllTenants(){
    final Future<Database> dbFuture = DatabaseHelper.databaseHelper.initializeDatabase();

    dbFuture.then((database){
      Future<List<Tenant>> tenantListFuture = DatabaseHelper.databaseHelper.getTenantList();
      tenantListFuture.then((tenants){
        if(mounted) {
          setState(() {
            tenantsList.tenant = tenants;
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAllTenants();
  }

  @override
  Widget build(BuildContext context) {

    //DatabaseHelper.databaseHelper.createTable();
    //DatabaseHelper.databaseHelper.deleteTable();

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
            //height: 800,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )
            ),
            child: Column(
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 20.0, right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      const Text(
                          'Home',
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
                            icon: tenantsList.setIcon(),
                          ),

                          IconButton(
                            onPressed: (){},
                            icon: const Icon(Icons.info_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

               Expanded(
                 child: DefaultTabController(
                     length: 3,
                     child: Column(
                       //mainAxisSize: MainAxisSize.min,
                       children: <Widget>[
                           Container(
                             padding: const EdgeInsets.symmetric(horizontal: 109.0),
                             child: TabBar(
                               indicatorColor: Colors.blue,
                               onTap: (index) {
                                 setState(() {
                                   currentIndex = index;
                                 });
                               },
                               tabs: [
                                 for (int i = 0; i < 3; i++)
                                   Tab(
                                     child: DotIndicator(
                                       isActive: currentIndex == i,
                                     ),
                                   ),
                               ],
                             ),
                           ),

                        Expanded(
                          child: TabBarView(
                              children: <Widget>[
                                RecordBar(tenantsNum: tenantsList.getPaidTenants().length, color: Colors.yellow[600], allTenantsNum: tenantsList.tenant.length, statusDisplay: 'PAID', filteredList: FilteredTenantList(tenantList: tenantsList.getPaidTenants())),

                                RecordBar(tenantsNum: tenantsList.getNFPaidTenants().length, color: Colors.green, allTenantsNum: tenantsList.tenant.length, statusDisplay: 'NOT FULLY PAID', filteredList: FilteredTenantList(tenantList: tenantsList.getNFPaidTenants())),

                                RecordBar(tenantsNum: tenantsList.getNotPaidTenants().length, color: Colors.red, allTenantsNum: tenantsList.tenant.length, statusDisplay: 'UNPAID', filteredList: FilteredTenantList(tenantList: tenantsList.getNotPaidTenants())),
                              ]
                          ),
                        )
                       ],
                     ),
                   ),
                 ),
              ],
            ),
          ),
     );
  }
}

