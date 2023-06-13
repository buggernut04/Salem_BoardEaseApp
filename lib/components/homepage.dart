import 'package:boardease_application/auxiliary/allpayed_tenantlist.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../auxiliary/recordbar.dart';
import '../classes/model/tenant.dart';
import '../database/databasehelper.dart';

class MyHomePage extends StatefulWidget    {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Tenant> tenants = [];


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
              style: TextStyle(fontSize: 23),
            ),
            centerTitle: false,
            backgroundColor: Colors.blue[300],
            elevation: 0.0,
            actions: [
              IconButton(
                onPressed: (){},
                icon: setIcon(),
              ),
            ],
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
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          //color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0,10.0),
                        child: const RecordBar()
                      ),

                      //Divider(height: 10.0,),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 30.0, 10.0,10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Payed: ${(_fetchPayedTenantCount())}',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                'Not Fully Payed: ${(_fetchNotFullyPayedTenantCount())}',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                'Not Payed: ${(_fetchNotPayedTenantCount())}',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ]
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(top: 20.0, right: 20),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Text(
                      "Tenants Payed(This Month)",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),

                const AllPayedTenants(),
              ],
            ),
          ),
    );
  }

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

  int _fetchNotFullyPayedTenantCount() {
    return tenants.where((tenant) => tenant.status == 2).length;
  }

  int _fetchNotPayedTenantCount() {
    return tenants.where((tenant) => tenant.status == 3).length;
  }

  int getTenantsDueInThreeDays(){
    return tenants.where((tenant) => tenant.isPaymentDueThreeDays() == true).length;
  }

  int getTenantsDueToday(){
    int count = 0;

    for (var tenant in tenants) {
      if (tenant.isPaymentDue()) {
        tenant.changeStatus(); // Change the value of the specific tenant
        count++;
      }
    }

    return count;
  }

  Icon setIcon(){
    //debugPrint('${(getTenantsDueToday())}');
    return getTenantsDueInThreeDays() != 0 ||  getTenantsDueToday() != 0 ? const Icon(Icons.notifications_active, color: Colors.red) : const Icon(Icons.notifications_none);
  }

}

