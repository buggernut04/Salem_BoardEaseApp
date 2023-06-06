import 'package:boardease_application/auxiliary/allpayed_tenants.dart';
import 'package:flutter/material.dart';
import '../auxiliary/recordbar.dart';
import '../database/databasehelper.dart';

class MyHomePage extends StatefulWidget    {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _allTenantsPayed = 0;
  int _allTenantsNotFullyPayed = 0;
  int _allTenantsNotPayed = 0;


  void _fetchPayedTenantCount() {
    DatabaseHelper.databaseHelper.getPayedTenantNum().then((count) {
      if(mounted) {
        setState(() {
          _allTenantsPayed = count!.toInt();
        });
      }
    });
  }

  void _fetchNotFullyPayedTenantCount() {
    DatabaseHelper.databaseHelper.getNotFullyPayedTenantNum().then((count) {
      if(mounted) {
        setState(() {
          _allTenantsNotFullyPayed = count!.toInt();
        });
      }
    });
  }

  void _fetchNotPayedTenantCount(){
    DatabaseHelper.databaseHelper.getNotPayedTenantNum().then((count) {
      if(mounted){
        setState(() {
          _allTenantsNotPayed = count!.toInt();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPayedTenantCount();
    _fetchNotFullyPayedTenantCount();
    _fetchNotPayedTenantCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.blue[300] ,
          appBar: AppBar(
            title: const Text(
                'BoardEase',
              style: TextStyle(fontSize: 23),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue[300],
            elevation: 0.0,
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
                                'Payed: ${(_allTenantsPayed)}',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                'Not Fully Payed: ${(_allTenantsNotFullyPayed)}',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                'Not Payed: ${(_allTenantsNotPayed)}',
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
}

