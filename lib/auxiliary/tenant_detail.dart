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

  static var _paymentStatus = ['Payed', 'Not Fully Payed', 'Not Payed'];

  @override
  Widget build(BuildContext context) {

    TextStyle? textStyle = Theme.of(context).textTheme.titleSmall;

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
                style: textStyle,
                onChanged: (value){},
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: textStyle,
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
                  style: textStyle,
                  onChanged: (value){},
                  decoration: InputDecoration(
                      labelText: 'Contact Number',
                      labelStyle: textStyle,
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
                  style: textStyle,
                  onChanged: (value){},
                  decoration: InputDecoration(
                      labelText: 'Starting Date',
                      labelStyle: textStyle,
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

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Rental Fee',
                  style: textStyle,
                ),
                ListTile(
                  title: DropdownButton(
                    items: _paymentStatus.map((String dropDownStringItem) => DropdownMenuItem<String>(
                      child: Text(dropDownStringItem),
                      value: dropDownStringItem,
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
                ),
              ],
            ),
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
                            setState(() {

                            });
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
