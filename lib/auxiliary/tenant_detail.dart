import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TenantDetail extends StatefulWidget {
  const TenantDetail({Key? key, required this.appBarTitle}) : super(key: key);

  final String appBarTitle;

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

  Padding controller(TextEditingController contName, String label){
    return Padding(
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: TextField(
          controller: contName,
          style: Theme.of(context).textTheme.titleSmall,
          onChanged: (value){},
          decoration: InputDecoration(
              labelText: label,
              labelStyle: Theme.of(context).textTheme.titleSmall,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0)
              )
          ),
        )
    );
  }

  final _paymentStatus = ['Payed', 'Not Fully Payed', 'Not Payed'];

  Column status(String title){
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
                value: 'Not Payed',
                onChanged: (valueSelectedByUser) {
                  setState(() {

                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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

            controller(nameController, 'Name'),
            controller(contactInfoController, 'Contact Number'),

            Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: datePicker,
                  style: Theme.of(context).textTheme.titleSmall,
                  onChanged: (value){},
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
                        datePicker.text = DateFormat.yMMMEd().format(pickedDate);
                      });
                    }
                  },
                )
            ),

            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),),

            status('Rental Fee'),
            status('Water Bill'),
            status('Electric Bill'),
            status('Additional Payment'),

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
                          onPressed: () {},
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
                            Navigator.pop(context);
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
