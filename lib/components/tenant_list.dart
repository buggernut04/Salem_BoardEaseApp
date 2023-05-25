import 'package:boardease_application/classes/paymentstatus.dart';
import 'package:flutter/material.dart';

import '../classes/tenant.dart';

class TenantList extends StatefulWidget {
  const TenantList({Key? key}) : super(key: key);

  @override
  State<TenantList> createState() => _TenantListState();
}

class _TenantListState extends State<TenantList> {

  List<Tenant> tenant = [
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09978601212', email: 'grrrr', status: PaymentStatus.notPayed, startDate: DateTime.now()),
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09978601212', email: 'grrrr', status: PaymentStatus.notPayed, startDate: DateTime.now()),
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09978601212', email: 'grrrr', status: PaymentStatus.notPayed, startDate: DateTime.now()),
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09978621212', email: 'grrrr', status: PaymentStatus.notFullyPayed, startDate: DateTime.now()),
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09438601212', email: 'grrrr', status: PaymentStatus.fullyPayed, startDate: DateTime.now())
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

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5.0),
        child: CustomScrollView(
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
                                    onTap: () {},
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
        )
    );
  }
}
