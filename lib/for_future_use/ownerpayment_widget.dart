/*
import 'package:boardease_application/for_future_use/ownerpaymentlist.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../database/databasehelper.dart';
import '../inputDetails/addpayment.dart';
import 'ownerpayment.dart';

class OwnerPaymentWidget extends StatefulWidget {
  const OwnerPaymentWidget({Key? key}) : super(key: key);

  @override
  State<OwnerPaymentWidget> createState() => _OwnerPaymentWidgetState();
}

class _OwnerPaymentWidgetState extends State<OwnerPaymentWidget> {
  // variables
  WPaymentList wPayment = WPaymentList(wPayments: []);
  List<TextEditingController> wPaymentController = [];
  List<String?> monthVal = [];

  final _months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  void saveWPayment(OwnerPayment ownerPay) async {
    int? result;

    result = await DatabaseHelper.databaseHelper.insertWPayment(ownerPay);

    result != 0 ? debugPrint('Success') : debugPrint('Fail');
  }

  void updateWPaymentListView(){
    final Future<Database> dbFuture = DatabaseHelper.databaseHelper.initializeDatabase();

    dbFuture.then((database){
      Future<List<OwnerPayment>> wPaymentListFuture = DatabaseHelper.databaseHelper.getWPaymentList();
      wPaymentListFuture.then((wPayments){
        if(mounted) {
          setState(() {
            wPayment.wPayments = wPayments;

            //debugPrint('${(count)}');
            if (wPayment.wPayments.isEmpty) {
              OwnerPayment w1 = OwnerPayment(id: null,
                  paymentName: 'Water Bill',
                  amount: null,
                  datePayed: DateTime.now());
              w1.saveWPayment();

              OwnerPayment w2 = OwnerPayment(id: null,
                  paymentName: 'Electric Bill',
                  amount: null,
                  datePayed: DateTime.now());
              w2.saveWPayment();
            }
          });
        }
      });
    });
  }

  void initializeToInputs(){
    for (int i = wPaymentController.length; i < wPayment.wPayments.length; i++) {
      wPaymentController.add(TextEditingController());
    }

    for (int i = monthVal.length; i < wPayment.wPayments.length; i++) {
      monthVal.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {

    updateWPaymentListView();

    return Container(
      padding: EdgeInsets.zero,
      child: ownerPayment(),
    );
  }

  Widget ownerPayment() {

    initializeToInputs();

    return Column(
      children: <Widget>[

        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 17.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[

              Text(
                'Monthly Payments',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),

              AddPayment(indicator: 'W'),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: wPayment.wPayments.length, // Add 1 for the ElevatedButton
            itemBuilder: (BuildContext context, int position) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                      child: ListTile(
                        title: Column(
                          children: [

                            TextField(
                              controller: wPaymentController[position],
                              style: Theme.of(context).textTheme.titleSmall,
                              onChanged: (value) {
                                setState(() {
                                  wPayment.wPayments[position].amount = int.tryParse(value) ?? 0;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: wPayment.wPayments[position].paymentName,
                                labelStyle: Theme.of(context).textTheme.titleSmall,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 10.0, bottom: 2.0),
                              child: Text(
                                'Month Paid (${DateTime.now().year})',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),

                            ListTile(
                              title: DropdownButton(
                                items: _months.map((String dropDownStringItem) => DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                )).toList(),
                                hint:  const Text('Choose month'),
                                value: monthVal[position],
                                onChanged: (valueSelectedByUser) {
                                  setState(() {
                                    monthVal[position] = valueSelectedByUser;

                                    debugPrint('${monthVal[position]}');

                                    wPayment.wPayments[position].datePayed = convertToDateTime(valueSelectedByUser);

                                    debugPrint('${wPayment.wPayments[position].datePayed}');
                                  });
                                },
                                dropdownColor: Colors.white,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 25,
                                isExpanded: true,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white70,
                                  ),
                                  child: const Text(
                                    'PAY',
                                    textScaleFactor: 1.5,
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  onPressed: () {

                                    wPayment.wPayments[position].saveWPayment();
                                    wPaymentController[position].clear();

                                  }),
                            ),
                          ],
                        ),
                        //trailing: EditDeletePayment(tenantPayment: tPayment[position]),
                      ),
                    ),
                  ],
                );
            },
          ),
        ),
      ],
    );
  }

  String getMonthAsString(int value) {
    if (value >= 1 && value <= 12) {
      return _months[value - 1];
    } else {
      throw Exception('Invalid month value: $value');
    }
  }

  DateTime convertToDateTime(String? value) {
    if (value != null) {
      final monthIndex = _months.indexOf(value);
      if (monthIndex != -1) {
        return DateTime(DateTime.now().year, monthIndex + 1, DateTime.now().day);
      }
    }
    throw Exception('Invalid month: $value');
  }


  Column datePayed(OwnerPayment ownerPayment) {

    String? monthVal = _months[DateTime.now().month - 1];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 1.0),
          child: Text(
            'Month Payed (${DateTime.now().year})',
              style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ListTile(
          title: DropdownButton(
            items: _months.map((String dropDownStringItem) => DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Text(dropDownStringItem),
            )).toList(),
            style: const TextStyle(color: Colors.black),
            value: monthVal,
            onChanged: (valueSelectedByUser) {
              setState(() {
                monthVal = valueSelectedByUser;
                ownerPayment.datePayed = convertToDateTime(valueSelectedByUser);
              });
            },
          ),
        ),
      ],
    );
  }
}
*/
