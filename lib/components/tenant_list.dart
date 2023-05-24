import 'package:boardease_application/classes/paymentstatus.dart';
import 'package:flutter/material.dart';

import '../classes/tenant.dart';

class TenantList extends StatefulWidget {
  const TenantList({Key? key, required this.tenant}) : super(key: key);

  final List<Tenant> tenant;

  @override
  State<TenantList> createState() => _TenantListState();
}

class _TenantListState extends State<TenantList> {

  String toPrint(int index){
    if(widget.tenant[index].status == PaymentStatus.fullyPayed) {
      return "${widget.tenant[index].name}\nFully Payed";
    }
    else if(widget.tenant[index].status == PaymentStatus.notFullyPayed) {
      return "${widget.tenant[index].name}\nNot Fully Payed";
    }
    return "${widget.tenant[index].name}\nNot Payed";
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
                    childCount: widget.tenant.length,
                )
            )
          ],
        )
    );;
  }
}
