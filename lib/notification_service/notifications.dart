import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/model/notification_body.dart';
import '../database/databasehelper.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  List<NotificationBody> notificationBody = [];

  void getNotifications(){
    final Future<Database> dbFuture = DatabaseHelper.databaseHelper.initializeDatabase();

    dbFuture.then((database){
      Future<List<NotificationBody>> notificationListFuture = DatabaseHelper.databaseHelper.getNotificationList();
      notificationListFuture.then((notifications){
        if(mounted) {
          setState(() {
            notificationBody = notifications;
          });
        }
      });
    });
  }

  @override
  void initState(){
    super.initState();
    getNotifications();
  }


  @override
  Widget build(BuildContext context) {

    getNotifications();

    return Scaffold(
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
              Navigator.pop(context, false);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 24.0, right: 8.0),
              child: Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                  itemCount: notificationBody.length,
                  itemBuilder: (BuildContext context, int position){
                    return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Card(
                            color: Colors.white,
                            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0,1.0),
                            elevation: 2.0,
                            child: ListTile(
                              onTap: () {
                                //routeToTenantStatus(tenantList.tenant[position]);
                              },
                              leading: const CircleAvatar(
                                foregroundImage: AssetImage('assets/app_logo.jpg') ,
                                radius: 20,
                              ),
                              title: Text(
                                  notificationBody[position].body,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  )
                              ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Text(
                                      DateFormat.yMMMd().format(notificationBody[position].timeCreated),
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      )
                                  ),

                                  Text(
                                      DateFormat('hh:mm a').format(notificationBody[position].timeCreated),
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      )
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent,),
                                onPressed: () async {
                                  notificationBody[position].removeNotification();
                                },
                              ),
                              dense: true,
                            )
                        )
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
