import 'package:boardease_application/classes/paymentstatus.dart';
import 'package:flutter/material.dart';

import '../auxiliary/tenant_detail.dart';
import '../classes/tenant.dart';

class TenantList extends StatefulWidget {
  const TenantList({Key? key}) : super(key: key);

  @override
  State<TenantList> createState() => _TenantListState();
}

class _TenantListState extends State<TenantList> {

  List<Tenant> tenant = [
    Tenant('Michael Cye R. Salem', '09978601212',  PaymentStatus.notPayed, DateTime.now()),

  ];

  String toPrint(int index){
    if(tenant[index].status == PaymentStatus.fullyPayed) {
      return "${tenant[index].name}\nFully Payed";
    }
    else if(tenant[index].status == PaymentStatus.notFullyPayed) {
      return "${tenant[index].name}\nNot Fully Payed";
    }
    return "${tenant[index].name}\nNot Payed";
  }

  void route(String title){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return TenantDetail(appBarTitle: title);
        })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('All Tenants'),
          backgroundColor: Colors.blue[300],
        ),
        body: CustomScrollView(
              //reverse: true,
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index){
                              return Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Card(
                                    margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0,1.0),
                                    child: ListTile(
                                        onTap: () {
                                          route('Edit Tenant');
                                        },
                                        title: Text(
                                          toPrint(index),
                                          style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.grey[600],
                                        )
                                    ),
                                  )
                              )
                            );
                        },
                        childCount: tenant.length,
                    )
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  route('Add Tenant');
                },
              child: Icon(Icons.add),
            )
    );
  }
}
