import 'package:boardease_application/database/databasehelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../classes/model/tenant.dart';

class TenantDetail extends StatefulWidget {
  const TenantDetail({Key? key, required this.appBarTitle, required this.tenant}) : super(key: key);

  final String appBarTitle;
  final Tenant tenant;

  @override
  State<TenantDetail> createState() => _TenantDetailState();
}

class _TenantDetailState extends State<TenantDetail> {

  TextEditingController nameController = TextEditingController();
  TextEditingController contactInfoController = TextEditingController();
  TextEditingController startDatePicker = TextEditingController();
  TextEditingController currentDatePicker = TextEditingController();

  Future<DateTime?> _showDatePicker(){
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
    );
  }

  final _paymentStatus = ['Payed', 'Not Payed'];

  String getStatusAsString(int value){
    String priority = value == 1 ?  _paymentStatus[0] : _paymentStatus[1];

    return priority;
  }

  int updateStatus(String value){
    return value == 'Payed' ? widget.tenant.status = 1 : value == 'Not Payed' ? widget.tenant.status = 3 : widget.tenant.status = 2;
  }

  Column status(String title, int value){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        ListTile(
          title: Column(
            children: <Widget>[
              DropdownButton(
                items: _paymentStatus.map((String dropDownStringItem) => DropdownMenuItem<String>(
                  value: dropDownStringItem,
                  child: Text(dropDownStringItem),
                )
                ).toList(),
                style: TextStyle(
                    color: Colors.black
                ),
                value: getStatusAsString(value),
                onChanged: (valueSelectedByUser) {
                  setState(() {
                    updateStatus(valueSelectedByUser!);
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
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
      result = await DatabaseHelper.databaseHelper.insertTenant(widget.tenant);
    }

    result != 0 ? debugPrint('Success') : debugPrint('Fail');
  }

  @override
  Widget build(BuildContext context) {

    nameController.text = widget.tenant.name;
    contactInfoController.text = widget.tenant.contactInfo;
    startDatePicker.text = DateFormat('yyyy-MM-dd').format(widget.tenant.startDate);
    currentDatePicker.text = DateFormat('yyyy-MM-dd').format(widget.tenant.currentDate);

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
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
              Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: nameController,
                  style: Theme.of(context).textTheme.titleSmall,
                  onChanged: (value){
                    widget.tenant.name = nameController.text;
                  },
                  decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: Theme.of(context).textTheme.titleSmall,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                )
            ),

            Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: contactInfoController,
                  style: Theme.of(context).textTheme.titleSmall,
                  onChanged: (value){
                    widget.tenant.contactInfo = contactInfoController.text;
                  },
                  decoration: InputDecoration(
                      labelText: 'Contact Number',
                      labelStyle: Theme.of(context).textTheme.titleSmall,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                )
            ),

            Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                    controller: startDatePicker,
                    style: Theme.of(context).textTheme.titleSmall,
                    decoration: InputDecoration(
                        labelText: 'Date Started to live',
                        labelStyle: Theme.of(context).textTheme.titleSmall,
                        icon: Icon(Icons.calendar_today_rounded
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await _showDatePicker();

                      if(pickedDate != null){
                        setState(() {
                          startDatePicker.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                          widget.tenant.startDate = pickedDate;
                        });
                      }
                  },
                )
            ),

            Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: currentDatePicker,
                  style: Theme.of(context).textTheme.titleSmall,
                  decoration: InputDecoration(
                    labelText: 'Current Date to Pay',
                    labelStyle: Theme.of(context).textTheme.titleSmall,
                    icon: Icon(Icons.calendar_today_rounded
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await _showDatePicker();

                    if(pickedDate != null){
                      setState(() {
                        currentDatePicker.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                        widget.tenant.currentDate = pickedDate;
                      });
                    }
                  },
                )
            ),

            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),),

            status('Rental Fee', widget.tenant.status),
            status('Water Bill', widget.tenant.status),
            status('Electric Bill', widget.tenant.status),
            status('Additional Payment', widget.tenant.status),

            Padding(
                padding: EdgeInsets.only(top: 13.0, bottom: 13.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(foregroundColor: Colors.white70
                          ),
                          child: Text(
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
                            style: TextStyle(
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
