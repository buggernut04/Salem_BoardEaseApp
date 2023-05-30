import 'package:flutter/material.dart';

import '../auxiliary/tenant_detail.dart';

class TenantList extends StatefulWidget {
  const TenantList({Key? key}) : super(key: key);

  @override
  State<TenantList> createState() => _TenantListState();
}

class _TenantListState extends State<TenantList> {

  int count = 0;

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
        body: ListView.builder(
                itemCount: count,
                itemBuilder: (BuildContext context, int position){
                  return Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Card(
                          margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0,1.0),
                          elevation: 1.0,
                          child: ListTile(
                            onTap: () {
                              route('Edit Tenant');
                            },
                            leading: CircleAvatar(
                              //set background color in a function when database  is applied
                              child: Icon(Icons.perm_identity_rounded),
                            ),
                            title: Text(
                                'Name of Tenant',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey[600],
                                )
                            ),
                            subtitle: Text('Date'),
                            trailing: Text('Status'),
                          )
                      )
                  );
                }
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
