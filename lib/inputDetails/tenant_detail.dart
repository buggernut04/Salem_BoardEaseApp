import 'package:boardease_application/classes/model/tenantlist.dart';
import 'package:boardease_application/database/databasehelper.dart';
import 'package:boardease_application/notification_service/notification_body.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/model/tenant.dart';

class TenantDetail extends StatefulWidget {
  const TenantDetail({Key? key, required this.appBarTitle, required this.tenant}) : super(key: key);

  final String appBarTitle;
  final Tenant tenant;

  @override
  State<TenantDetail> createState() => _TenantDetailState();
}

class _TenantDetailState extends State<TenantDetail> {

  final formKey = GlobalKey<FormState>();


  TenantList tenantList = TenantList(tenant: []);
  bool nameCanBeSave = false;
  bool numCanBeSave = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController contactInfoController = TextEditingController();
  TextEditingController startDatePicker = TextEditingController();

  @override
  void initState() {
    super.initState();
    getValList();
  }

  @override
  void dispose(){
    super.dispose();
    nameController.dispose();
    contactInfoController.dispose();
    startDatePicker.dispose();
  }

  void getValList() {
    final Future<Database> dbFuture = DatabaseHelper.databaseHelper.initializeDatabase();

    dbFuture.then((database){
      Future<List<Tenant>> tenantListFuture = DatabaseHelper.databaseHelper.getTenantList();
      tenantListFuture.then((tenants){
        if(mounted) {
          setState(() {
            tenantList.tenant = tenants;
          });
        }
      });
    });
  }

  bool validateName(String name) {
    final regex = RegExp(r'^([A-Z][a-z]*(\s+[A-Z][a-zA-Z]*)*)$');
    return regex.hasMatch(name);
  }

  bool validatePhoneNumber(String phoneNumber) {
    RegExp phoneNumberRegex = RegExp(r'^[0-9]{10}$');

    if (phoneNumberRegex.hasMatch(phoneNumber)) {
      if (phoneNumber.startsWith('9')) {
        // Add 0 at the beginning
        phoneNumber = '0$phoneNumber';
      }
      return true; // Valid phone number
    } else {
      return false; // Invalid phone number
    }
  }

  Future<DateTime?> _showDatePicker(){
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
    );
  }

  @override
  Widget build(BuildContext context) {

    nameController.text = widget.tenant.name;
    contactInfoController.text = widget.tenant.contactInfo;
    startDatePicker.text = startDatePicker.text = DateFormat.yMMMd().format(widget.tenant.startDate);

    //final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
                Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    controller: nameController,
                    style: Theme.of(context).textTheme.titleSmall,
                    validator: (value){
                      if (value!.isEmpty) {
                        return 'Please enter a name';
                      } else if(!tenantList.checkIfNameExists(value)){
                        return 'Tenant already exist';
                      } else if(!validateName(value)){
                        return 'Invalid name format';
                      }
                      nameCanBeSave = true;
                      return null;
                    },
                    onChanged: (value){
                      widget.tenant.name = nameController.text;
                    },
                    decoration: InputDecoration(
                        labelStyle: Theme.of(context).textTheme.titleSmall,
                        hintText: 'Enter Tenant Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        ),
                        labelText: 'Tenant Name',
                      prefixIcon: const Icon(Icons.person, color: Colors.grey,),
                    ),
                  )
              ),

              Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    controller: contactInfoController,
                    keyboardType: TextInputType.number,
                    style: Theme.of(context).textTheme.titleSmall,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a phone number';
                      } else if (!tenantList.checkIfPhoneNumberExists(value)) {
                        return 'Phone Number already exist';
                      } else if(!validatePhoneNumber(value)){
                        return 'Invalid Phone Number';
                      }
                      numCanBeSave = true;
                      return null;
                    },
                    onChanged: (value){
                      widget.tenant.contactInfo = contactInfoController.text;
                    },
                    decoration: InputDecoration(
                        labelStyle: Theme.of(context).textTheme.titleSmall,
                        hintText: 'Enter Contact Number',
                        labelText: 'Contact Number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                        ),
                        prefixText: '+63 ',
                        prefixIcon: const Icon(Icons.phone_android_rounded, color: Colors.grey,),
                    ),
                    maxLength: 10,
                  )
              ),

              Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                  child: TextFormField(
                      controller: startDatePicker,
                      style: Theme.of(context).textTheme.titleSmall,
                      decoration: InputDecoration(
                          labelText: 'Date Started To Live',
                          labelStyle: Theme.of(context).textTheme.titleSmall,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)
                          ),
                          prefixIcon: const Icon(
                            Icons.calendar_today, // Replace with the desired icon
                            color:Colors.grey, // Customize the icon color if needed
                          ),
                      ),

                      onTap: () async {
                        DateTime? pickedDate = await _showDatePicker();

                        if(pickedDate != null){
                          setState(() {
                            startDatePicker.text = DateFormat.yMMMd().format(pickedDate);
                            widget.tenant.startDate = pickedDate;
                          });
                        }
                    },
                  )
              ),

              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),),

              Padding(
                  padding: const EdgeInsets.only(top: 13.0, bottom: 13.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(foregroundColor: Colors.white70
                            ),
                            child: const Text(
                                'Save',
                                textScaleFactor: 1.5,
                                style: TextStyle(
                                  color: Colors.blue
                                ),
                            ),
                            onPressed: () {
                              if(formKey.currentState!.validate()){
                                widget.tenant.saveTenant();

                                cancelAllNotifications();

                                tenantList.tenant.length <= 1 && widget.tenant.status != 1 ?  getTenantNotificationWhenAlmostDue(widget.tenant): tenantList.getTenantForNotification();
                                
                                const snackBar = SnackBar(content: Text('Tenant Added'));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                Navigator.pop(context, true);
                              } else {
                                debugPrint('Error');
                              }
                            },
                          )
                      ),

                      Container(width: 8.0,),

                      Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(foregroundColor: Colors.white70),
                            child: const Text(
                              'Cancel',
                              textScaleFactor: 1.5,
                              style: TextStyle(
                                  color: Colors.blue
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                          )
                      )
                    ],
                  ),
              ),
            ],
          )
        ),
      )
    );
  }
}
