import 'package:boardease_application/classes/model/tenantpayment.dart';
import 'package:boardease_application/database/databasehelper.dart';
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

  List<TenantPayment> tenantPayments = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController contactInfoController = TextEditingController();
  TextEditingController startDatePicker = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllTPaymentList();
  }

  Future<DateTime?> _showDatePicker(){
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
    );
  }

  void getAllTPaymentList() {
    final Future<Database> dbFuture = DatabaseHelper.databaseHelper.initializeDatabase();

    dbFuture.then((database){
      Future<List<TenantPayment>> tPaymentListFuture = DatabaseHelper.databaseHelper.getTPaymentList();
      tPaymentListFuture.then((tPayments){
          setState(() {
            //debugPrint('${()}')
            widget.tenant.tenantPayment = tPayments;
          });
      });
    });
  }

  // remove a tenant
  void removeTenant(BuildContext context, Tenant tenant) async {
    int? result = await DatabaseHelper.databaseHelper.deleteTenant(widget.tenant.id);

    if(result != 0){
      showSnackBar(context, 'Tenant Removed');
    }
  }

  void showSnackBar(BuildContext context, String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // save the tenant to the database
  void saveTenant() async {
    int? result;

    if(widget.tenant.id != null){
      result = await DatabaseHelper.databaseHelper.updateTenant(widget.tenant);
    } else{
      // If when the tenant will start to live, that is also the day he will start his/her payment.
      // Base on my stakeholder advise
      widget.tenant.currentDate = widget.tenant.startDate;

      result = await DatabaseHelper.databaseHelper.insertTenant(widget.tenant);
    }

    result != 0 ? debugPrint('Success') : debugPrint('Fail');
  }

  @override
  Widget build(BuildContext context) {

    nameController.text = widget.tenant.name;
    contactInfoController.text = widget.tenant.contactInfo;
    startDatePicker.text = startDatePicker.text = DateFormat.yMMMd().format(widget.tenant.startDate);


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
              Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: nameController,
                  style: Theme.of(context).textTheme.titleSmall,
                  onChanged: (value){
                    widget.tenant.name = nameController.text;
                  },
                  decoration: InputDecoration(
                      labelStyle: Theme.of(context).textTheme.titleSmall,
                      hintText: 'Enter Tenant Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                )
            ),

            Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: contactInfoController,
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.titleSmall,
                  onChanged: (value){
                    widget.tenant.contactInfo = contactInfoController.text;
                  },
                  decoration: InputDecoration(
                      labelStyle: Theme.of(context).textTheme.titleSmall,
                      hintText: 'Enter Contact Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                      )
                  ),
                )
            ),

            Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
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
                            saveTenant();
                            Navigator.pop(context, true);
                          },
                        )
                    ),

                    Container(width: 8.0,),

                    Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(foregroundColor: Colors.white70),
                          child: Text( widget.appBarTitle == 'Add Tenant' ? 'Cancel' : 'Remove',
                            textScaleFactor: 1.5,
                            style: const TextStyle(
                                color: Colors.blue
                            ),
                          ),
                          onPressed: () {
                            if(widget.appBarTitle == 'Edit Tenant') {
                              removeTenant(context, widget.tenant);
                            }

                            Navigator.pop(context, true);
                          },
                        )
                    )
                  ],
                ),
            ),
          ],
        )
      )
    );
  }
}
