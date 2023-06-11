import 'package:flutter/material.dart';

import '../classes/model/ownerpayment.dart';
import '../classes/model/tenantpayment.dart';
import '../database/databasehelper.dart';


class AddPayment extends StatefulWidget {
  const AddPayment({Key? key, required this.indicator}) : super(key: key);

  final String indicator;

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {

  TextEditingController pName = TextEditingController();
  TextEditingController amount = TextEditingController();

  void saveTPayment(TenantPayment tenantPayment) async {
    int? result;

    result = await DatabaseHelper.databaseHelper.insertTPayment(tenantPayment);

    result != 0 ? debugPrint('Success') : debugPrint('Fail');
  }

  void saveWPayment(OwnerPayment ownerPayment) async {
    int? result;

    result = await DatabaseHelper.databaseHelper.insertWPayment(ownerPayment);

    result != 0 ? debugPrint('Success') : debugPrint('Fail');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white70,
        ),
        child: const Text(
          'Add Payment',
          textScaleFactor: 1.5,
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        onPressed: () {
          openDialog();
        },
      ),
    );
  }

  void openDialog() => showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: SizedBox(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: pName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Payment Name',
                  ),
                ),
              ),

              const SizedBox(height: 10.0),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: amount,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Amount',
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {

                    if(widget.indicator == 'T'){
                      saveTPayment(TenantPayment(id: null, paymentName: pName.text, amount: int.tryParse(amount.text) ?? 0, isPayed: 0));
                    } else{
                      saveWPayment(OwnerPayment(id: null, paymentName: pName.text, amount: int.tryParse(amount.text) ?? 0, datePayed: DateTime.now()));
                    }

                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    'ADD',
                    textScaleFactor: 1.5,
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 1),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    'CANCEL',
                    textScaleFactor: 1.5,
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}