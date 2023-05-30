import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentDetail extends StatefulWidget {
  const PaymentDetail({Key? key}) : super(key: key);

  @override
  State<PaymentDetail> createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {

  TextEditingController rentalFeeController = TextEditingController();

  TextEditingController waterConsumptionController = TextEditingController();
  TextEditingController electricConsumptionController = TextEditingController();
  TextEditingController datepicked = TextEditingController();

  ListView tenantPayment(){
    return ListView(
      children: <Widget>[
        Padding(
            padding:  EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: TextField(
              controller: rentalFeeController,
              style: Theme.of(context).textTheme.titleSmall,
              onChanged: (value){},
              decoration: InputDecoration(
                  labelText: 'Rental Fee',
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                  )
              ),
            )
        ),
        TextButton(
            onPressed: (){},
            child: Padding(
              padding: EdgeInsets.only(top: 13.0, bottom: 13.0,right: 270.0),
              child: Text(
                'Add Payment',
                textScaleFactor: 1.2,
                style: TextStyle(
                    color: Colors.blue,
                ),
              ),
            )
        ),
        Center(
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
          ),
        ),
      ]
    );
  }

  Future<DateTime?> _showDatePicker(){
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
    );
  }

  ListView ownerPayment(){
    return ListView(
        children: <Widget>[
          Padding(
              padding:  EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: TextField(
                controller: waterConsumptionController,
                style: Theme.of(context).textTheme.titleSmall,
                onChanged: (value){},
                decoration: InputDecoration(
                    labelText: 'Water Bill',
                    labelStyle: Theme.of(context).textTheme.titleSmall,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    )
                ),
              )
          ),
          Padding(
              padding:  EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: TextField(
                controller: electricConsumptionController,
                style: Theme.of(context).textTheme.titleSmall,
                onChanged: (value){},
                decoration: InputDecoration(
                    labelText: 'Electrtic Bill',
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
                controller: datepicked,
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
                      datepicked.text = DateFormat.yMMMEd().format(pickedDate);
                    });
                  }
                },
              )
          ),
          Center(
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
              ),
           ),
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
          centerTitle: true,
          backgroundColor: Colors.blue[300],
          elevation: 0.0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TabBar(
                tabs: [
                  Tab(
                    child: Text(
                        'Tenant Payment',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[600],
                        )
                    ),
                  ),
                  Tab(
                    child: Text(
                        'Owner Payment',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[600],
                        )
                    ),
                  )
                ]
            ),
            Expanded(
              child: TabBarView(
                  children: <Widget>[
                    tenantPayment(),
                    ownerPayment(),
                  ]
              ),
            )
          ],
        )
      ),
    );
  }
}
