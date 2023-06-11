import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../database/databasehelper.dart';
import '../../dialogBox/addpayment.dart';
import '../model/ownerpayment.dart';

class OwnerPaymentWidget extends StatefulWidget {
  const OwnerPaymentWidget({Key? key}) : super(key: key);

  @override
  State<OwnerPaymentWidget> createState() => _OwnerPaymentWidgetState();
}

class _OwnerPaymentWidgetState extends State<OwnerPaymentWidget> {

  // variables
  int count = 0 ;
  List<OwnerPayment> wPayment = [];
  List<TextEditingController> wPaymentController = [TextEditingController()];

  final _months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  DateTime selectedDate = DateTime.now();

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
            wPayment = wPayments;
            count = wPayments.length;

            //debugPrint('${(count)}');
            if (count == 0) {
              saveWPayment(OwnerPayment(id: null,
                  paymentName: 'Water Bill',
                  amount: 0,
                  datePayed: DateTime.now()));
              saveWPayment(OwnerPayment(id: null,
                  paymentName: 'Electric Bill',
                  amount: 0,
                  datePayed: DateTime.now()));
            }
          });
        }
      });
    });
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

    if (wPaymentController.length < count) {
      for (int i = wPaymentController.length; i < count; i++) {
        wPaymentController.add(TextEditingController(
          text: wPayment[i].amount.toString(),
        ));
      }
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: count + 1, // Add 1 for the ElevatedButton
            itemBuilder: (BuildContext context, int position) {
              if (position < count) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                  child: ListTile(
                    title: Column(
                      children: [
                        TextField(
                          controller: wPaymentController[position],
                          style: Theme.of(context).textTheme.titleSmall,
                          onChanged: (value) {
                            setState(() {
                              wPayment[position].amount = int.tryParse(value) ?? 0;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: wPayment[position].paymentName,
                            labelStyle: Theme.of(context).textTheme.titleSmall,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        datePayed(wPayment[position], selectedDate, onDateChanged),
                      ],
                    ),
                    //trailing: EditDeletePayment(tenantPayment: tPayment[position]),
                  ),
                );
              } else {
                // Render the ElevatedButton as the last item
                return const AddPayment(indicator: 'W');
              }
            },
          ),
        ),
      ],
    );
  }

  void onDateChanged(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
  }

  Column datePayed(OwnerPayment ownerPayment, DateTime selectedDate, Function(DateTime) onDateChanged) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 1.0),
          child: Text(
            'Month Payed (${selectedDate.year})',
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
            value: _months[selectedDate.month - 1],
            onChanged: (valueSelectedByUser) {
              final monthIndex = _months.indexOf(valueSelectedByUser!);
              final newDate = DateTime(selectedDate.year, monthIndex + 1, selectedDate.day);
              onDateChanged(newDate);
            },
          ),
        ),
      ],
    );
  }
}
