import 'package:boardease_application/classes/model/tenantlist.dart';
import 'package:boardease_application/inputDetails/tenant_status.dart';
import 'package:boardease_application/classes/model/tenant.dart';
import 'package:boardease_application/database/databasehelper.dart';
import 'package:boardease_application/notification_service/popup_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../classes/model/sort_options.dart';
import '../inputDetails/tenant_detail.dart';
import '../notification_service/notification_information.dart';

class TenantRecord extends StatefulWidget {
  const TenantRecord({Key? key}) : super(key: key);

  @override
  State<TenantRecord> createState() => _TenantRecordState();
}

class _TenantRecordState extends State<TenantRecord> {
  TenantList tenantList = TenantList(tenant: []);
  List<Tenant> filteredTenantList = [];
  SortOption sortOption = SortOption.Name;

  @override
  void initState() {
    super.initState();
    updateListView();
  }

  void updateListView() async {
    final tenants = await DatabaseHelper.databaseHelper.getTenantList();
    if (mounted) {
      setState(() {
        tenantList.tenant = tenants;
        filteredTenantList = tenants;
      });
    }
  }

  void routeToTenantDetail(Tenant tenant, String title) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return TenantDetail(appBarTitle: title, tenant: tenant);
      }),
    );
    if (result != null && result) {
      updateListView();
    }
  }

  void routeToTenantStatus(Tenant tenant) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return TenantStatus(tenant: tenant);
      }),
    );
    if (result != null && result) {
      updateListView();
    }
  }

  Widget buildSearch() => Container(
    height: 42,
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: Colors.white,
      border: Border.all(color: Colors.black26),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 3),
    child: TextField(
      decoration: const InputDecoration(
        icon: Icon(Icons.search),
        hintText: 'Search Tenant',
        border: InputBorder.none,
      ),
      onChanged: (value) => _runFilter(value),
    ),
  );

  void _runFilter(String enteredKeyword) {
    setState(() {
      if (enteredKeyword.isEmpty) {
        filteredTenantList = tenantList.tenant;
      } else {
        filteredTenantList = tenantList.tenant
            .where((tenant) => tenant.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Tenant> sortedTenantList = List.from(filteredTenantList);

    if (sortOption == SortOption.Name) {
      sortedTenantList.sort((a, b) => a.name.compareTo(b.name));
    } else if (sortOption == SortOption.Date) {
      sortedTenantList.sort((a, b) => a.startDate.compareTo(b.currentDate));
    } else if (sortOption == SortOption.Status) {
      sortedTenantList.sort((a, b) => a.status.compareTo(b.status));
    }

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
          ),
        ),
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 20.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Records',
                    style: TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Center(child: Text('Sort By')),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: const Text('Name'),
                                  onTap: () {
                                    setState(() {
                                      sortOption = SortOption.Name;
                                      Navigator.of(context).pop();
                                    });
                                  },
                                ),
                                ListTile(
                                  title: const Text('Date'),
                                  onTap: () {
                                    setState(() {
                                      sortOption = SortOption.Date;
                                      Navigator.of(context).pop();
                                    });
                                  },
                                ),
                                ListTile(
                                  title: const Text('Status'),
                                  onTap: () {
                                    setState(() {
                                      sortOption = SortOption.Status;
                                      Navigator.of(context).pop();
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.sort),
                  ),
                ],
              ),
            ),

            buildSearch(),

            filteredTenantList.isEmpty
                ? Center(
              child: Text(
                'No records',
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            )
                : Expanded(
              child: SlidableAutoCloseBehavior(
                closeWhenOpened: true,
                child: ListView.builder(
                  itemCount: sortedTenantList.length,
                  itemBuilder: (BuildContext context, int position) {

                    final tenant = sortedTenantList[position];

                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const BehindMotion(),
                        children: [
                          SlidableAction(
                              onPressed: (value){
                                routeToTenantDetail(tenant, 'Edit Tenant');
                              },
                              icon: Icons.edit,
                              backgroundColor: Colors.green,
                              borderRadius: BorderRadius.circular(10.0),
                          ),
                          SlidableAction(
                            onPressed: (value)async {
                              PopUpNotification.removeTenantInfo(context, tenant);

                              cancelAllNotifications();

                              if (tenantList.tenant.isNotEmpty) {
                                tenantList.getTenantForNotification();
                              }
                            },
                            icon: Icons.delete,
                            backgroundColor: Colors.redAccent,
                            borderRadius: BorderRadius.circular(10.0),
                          )
                        ],
                      ),
                      child: Card(
                        key: ValueKey(tenant.id),
                        color: Colors.white,
                        margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 1.0),
                        elevation: 2.0,
                        child: ListTile(
                          onTap: () {
                            routeToTenantStatus(tenant);
                          },
                          leading: CircleAvatar(
                            foregroundImage: tenant.getStatusImage(),
                            foregroundColor: tenant.getStatusColor(),
                            radius: 15,
                          ),
                          title: Text(
                            tenant.name.toString(),
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Status: ${tenant.getStatus()}',
                            style: TextStyle(
                              fontSize: 13.0,
                              color: tenant.getStatusColor(),
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios_sharp, color: Colors.black,),
                          dense: true,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          routeToTenantDetail(
            Tenant(name: '', contactInfo: '', status: 3, startDate: DateTime.now(), currentDate: DateTime.now(), tenantPayment: []),
            'Add Tenant',
          );
        },
        backgroundColor: Colors.white60,
        child: Icon(
          Icons.person_add,
          color: Colors.blue[900],
          size: 30,
        ),
      ),
    );
  }
}
