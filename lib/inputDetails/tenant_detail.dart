import 'package:boardease_application/classes/model/tenantlist.dart';
import 'package:boardease_application/database/databasehelper.dart';
import 'package:boardease_application/notification_service/notification_information.dart';
import 'package:boardease_application/notification_service/popup_notification.dart';
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
  bool isFormEdited = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController contactInfoController = TextEditingController();
  TextEditingController startDatePicker = TextEditingController();

  @override
  void initState() {
    super.initState();
    getValList();

    // Set the initial values of the text form fields
    nameController.text = widget.tenant.name;
    contactInfoController.text = widget.tenant.contactInfo;
    startDatePicker.text = DateFormat.yMMMd().format(widget.tenant.startDate);
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
    final regex = RegExp(r'[A-Z][a-zA-Z]*$');
    return regex.hasMatch(name);
  }

  bool validatePhoneNumber(String phoneNumber) {
    final regex = RegExp(r'^9[0-9]{9}$');
    if (regex.hasMatch(phoneNumber) && phoneNumber.length == 10) {
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

    return WillPopScope(
      onWillPop: () async {
        if (isFormEdited) {
          PopUpNotification.cancelInfo(context);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                if(isFormEdited){
                  PopUpNotification.cancelInfo(context);
                }else {
                  Navigator.pop(context, false);
                }
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
            children: [

              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Center(
                  child:  Text(
                      '${widget.appBarTitle} Information',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                        fontSize: 22.0,
                      ),
                  ),
                ),
              ),

              Expanded(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                    child: ListView(
                      children: <Widget>[

                          Padding(
                          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                            child: TextFormField(
                              controller: nameController,
                              style: Theme.of(context).textTheme.titleMedium,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value){
                                if (value!.isEmpty) {
                                  return 'Please enter a name';
                                } else if( widget.appBarTitle == 'Add Tenant'  && tenantList.checkIfNameExists(value)){
                                  return 'Tenant already exist';
                                } else if(!validateName(value)){
                                  return 'Invalid name format';
                                }
                                return null;
                              },
                              onChanged: (value){

                                widget.tenant.name = nameController.text;

                                setState(() {
                                  isFormEdited = true;
                                });
                              },
                              decoration: InputDecoration(
                                  labelStyle: Theme.of(context).textTheme.titleSmall,
                                  hintText: 'Enter Tenant Name',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)
                                  ),
                                  labelText: 'Tenant Name',
                                prefixIcon: const Icon(Icons.person, color: Colors.black,),
                              ),
                            )
                        ),

                        Padding(
                            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                            child: TextFormField(
                              controller: contactInfoController,
                              keyboardType: TextInputType.phone,
                              style: Theme.of(context).textTheme.titleMedium,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a phone number';
                                } else if ( widget.appBarTitle == 'Add Tenant' && tenantList.checkIfPhoneNumberExists(value)) {
                                  return 'Phone Number already exist';
                                } else if(!validatePhoneNumber(value)){
                                  return 'Invalid Phone Number';
                                }
                                return null;
                              },
                              onChanged: (value){
                                widget.tenant.contactInfo = contactInfoController.text;
                                setState(() {
                                  isFormEdited = true;
                                });
                              },
                              decoration: InputDecoration(
                                  labelStyle: Theme.of(context).textTheme.titleSmall,
                                  hintText: 'Enter Contact Number',
                                  labelText: 'Contact Number',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  prefixText: '+63 ',
                                  prefixIcon: const Icon(Icons.phone_android_rounded, color: Colors.black,),
                              ),
                              maxLength: 10,
                            )
                        ),

                        Padding(
                            padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                            child: TextFormField(
                                controller: startDatePicker,
                                style: Theme.of(context).textTheme.titleMedium,
                                decoration: InputDecoration(
                                    labelText: 'Date Started To Live',
                                    labelStyle: Theme.of(context).textTheme.titleSmall,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0)
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.calendar_today, // Replace with the desired icon
                                      color:Colors.cyan, // Customize the icon color if needed
                                    ),
                                ),
                                onTap: () async {
                                  setState(() {
                                    isFormEdited = true;
                                  });

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
                                      onPressed: isFormEdited
                                          ? () {
                                          if (formKey.currentState!.validate()) {
                                            widget.tenant.saveTenant();

                                            cancelAllNotifications();

                                            tenantList.tenant.length <= 1 && widget.tenant.status != 1
                                                ? getTenantNotificationWhenAlmostDue(widget.tenant)
                                                : tenantList.getTenantForNotification();

                                            PopUpNotification.saveInfo(context, widget.appBarTitle == 'Add Tenant' ? 1 : 2);
                                        } else {
                                            debugPrint('Error');
                                        }
                                      } : null,
                                      child: const Text(
                                          'Save',
                                          textScaleFactor: 1.5,
                                          style: TextStyle(
                                              color: Colors.blue
                                          ),
                                      ), // Disable button if no edits made
                                    ),
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
                                        if(isFormEdited){
                                          PopUpNotification.cancelInfo(context);
                                        } else{
                                          Navigator.pop(context,false);
                                        }
                                      },
                                    )
                                )
                              ],
                            ),
                        ),
                      ],
                    )
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
