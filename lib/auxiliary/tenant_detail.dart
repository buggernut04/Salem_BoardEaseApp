import 'package:boardease_application/database/databasehelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../classes/tenant.dart';

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
  TextEditingController datePicker = TextEditingController();

  Future<DateTime?> _showDatePicker(){
    return showDatePicker(
        context: context, 
        initialDate: DateTime.now(), 
        firstDate: DateTime(2000), 
        lastDate: DateTime(2099),
    );
  }

  final _paymentStatus = ['Payed', 'Not Fully Payed', 'Not Payed'];

  String getStatusAsString(int value){
    String priority = value == 1 ?  _paymentStatus[0] : value == 2 ?  _paymentStatus[1] : _paymentStatus[2];
    return priority;
  }

  void updateStatusAsInt(String value){
    value == 'Payed' ? widget.tenant.status = 1 : value == 'Not Fully Payed' ? widget.tenant.status = 2 : widget.tenant.status = 3;
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
                    updateStatusAsInt(valueSelectedByUser!);
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

  String removeOrCancel(){
    String label = '';

    widget.appBarTitle == 'Add Tenant' ? label = 'Cancel' : label = 'Remove';

    return label;
  }


  @override
  Widget build(BuildContext context) {

    nameController.text = widget.tenant.name;
    contactInfoController.text = widget.tenant.contactInfo;
    datePicker.text = DateFormat('MM-dd-yyyy').format(widget.tenant.startDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
        elevation: 0.0,
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
                  controller: datePicker,
                  style: Theme.of(context).textTheme.titleSmall,
                  onChanged: (value){
                    widget.tenant.startDate = datePicker as DateTime;
                  },
                  decoration: InputDecoration(
                      labelText: 'Starting Date',
                      labelStyle: Theme.of(context).textTheme.titleSmall,
                      icon: Icon(Icons.calendar_today_rounded
                      ),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await _showDatePicker();

                    if(pickedDate != null){
                      setState(() {
                        datePicker.text = DateFormat.yMMMd(pickedDate) as String;
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
                          child: Text( removeOrCancel(),
                            textScaleFactor: 1.5,
                            style: TextStyle(
                                color: Colors.blue
                            ),
                          ),
                          onPressed: () {
                            removeTenant(context, widget.tenant);
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
