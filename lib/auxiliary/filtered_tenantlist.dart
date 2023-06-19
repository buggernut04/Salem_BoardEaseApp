import 'package:boardease_application/components/tenant_record.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/model/tenant.dart';
import '../database/databasehelper.dart';
import '../inputDetails/tenant_status.dart';

class FilteredTenantList extends StatefulWidget {
  FilteredTenantList({Key? key, required this.tenantList}) : super(key: key);

  List<Tenant> tenantList;

  @override
  State<FilteredTenantList> createState() => _FilteredTenantListState();
}

class _FilteredTenantListState extends State<FilteredTenantList> {

  void routeToTenantStatus(Tenant tenant) async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return TenantStatus(tenant: tenant);
        })
    );

    if(result){
      final Future<Database> dbFuture = DatabaseHelper.databaseHelper.initializeDatabase();

      dbFuture.then((database){
        Future<List<Tenant>> tenantListFuture = DatabaseHelper.databaseHelper.getTenantList();
        tenantListFuture.then((tenants){
          if(mounted) {
            setState(() {
              widget.tenantList = tenants;
            });
          }
        });
      });
    }
  }

  String dateInfo(DateTime dt) => DateFormat('MMMM d, y').format(dt);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'List as of ${DateFormat('MMMM').format(DateTime.now())} ${DateTime.now().year.toString()}',
                    style: const TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                ),

                TextButton(
                    child: const Text(
                      'See All',
                      style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
                          letterSpacing: 0.5
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const TenantRecord()
                        ),
                      );
                    },
                ),
              ],
            ),
        ),

        Expanded(
          child: ListView.builder(
          itemCount: widget.tenantList.length,
          itemBuilder: (BuildContext context, int position){
            return Padding(
                padding: const EdgeInsets.all(1.0),
                child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0,1.0),
                    elevation: 2.0,
                    child: ListTile(
                      onTap: () {
                        routeToTenantStatus(widget.tenantList[position]);
                      },
                      leading: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.perm_identity_rounded),
                      ),
                      title: Text(
                          widget.tenantList[position].name.toString(),
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey[600],
                          )
                      ),
                      subtitle: Text(
                        'Payment until: ${dateInfo(widget.tenantList[position].currentDate)}',
                          style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic
                              ),
                      ),
                      trailing:Text(
                          'See Status',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          )
                      ),
                    )
                )
              );
            }
          ),
        ),
      ],
    );
  }
}
