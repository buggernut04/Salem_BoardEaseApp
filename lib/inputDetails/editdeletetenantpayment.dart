import 'package:flutter/material.dart';

import '../classes/model/tenantpayment.dart';
import '../database/databasehelper.dart';


class EditDeleteTenantPayment extends StatefulWidget {
  const EditDeleteTenantPayment({Key? key, required this.tenantPayment}) : super(key: key);

  final TenantPayment tenantPayment;

  @override
  State<EditDeleteTenantPayment> createState() => _EditDeleteTenantPaymentState();
}

class _EditDeleteTenantPaymentState extends State<EditDeleteTenantPayment> {

  TextEditingController pName = TextEditingController();
  TextEditingController amount = TextEditingController();

  void saveTPayment() async {
    int? result;

    result = await DatabaseHelper.databaseHelper.updateTPayment(widget.tenantPayment);

    result != 0 ? debugPrint('Success') : debugPrint('Fail');
  }

  void removeTPayment(TenantPayment tPay) async {
    await DatabaseHelper.databaseHelper.deleteTPayment(tPay.id);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            openDialog().then((shouldUpdate) {
              if (shouldUpdate) {
                setState(() {
                  // Update the values of the tenantPayment
                  widget.tenantPayment.paymentName = pName.text;
                  widget.tenantPayment.amount = int.tryParse(amount.text) ?? 0;
                });
              }
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            removeTPayment(widget.tenantPayment);
          },
        ),
      ],
    );
  }

  Future openDialog() => showDialog(
    context: context,
    builder: (context) {

      pName.text = widget.tenantPayment.paymentName;
      amount.text = widget.tenantPayment.amount.toString();

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
                  onTap: (){
                    setState(() {
                      widget.tenantPayment.paymentName = pName.text;
                    });
                  },
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
                  onTap: (){
                    setState(() {
                      widget.tenantPayment.amount = int.tryParse(amount.text) ?? 0;
                    });
                  },
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    saveTPayment();
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(
                    'SAVE',
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
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false); // Close the dialog
                      },
                      child: const Text(
                        'CANCEL',
                        textScaleFactor: 1.5,
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}