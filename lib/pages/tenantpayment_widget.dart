import 'package:boardease_application/inputDetails/editdeletetenantpayment.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../database/databasehelper.dart';
import '../inputDetails/addpayment.dart';
import '../classes/model/tenantpayment.dart';

class TenantPaymentWidget extends StatefulWidget {
  const TenantPaymentWidget({Key? key}) : super(key: key);

  @override
  State<TenantPaymentWidget> createState() => _TenantPaymentWidgetState();
}

class _TenantPaymentWidgetState extends State<TenantPaymentWidget> {
  List<TenantPayment> tPayment = [];

  List<TextEditingController> tPaymentController = [];

  void saveTPayment(TenantPayment tenantPayment) async {
    int? result;

    result = await DatabaseHelper.databaseHelper.insertTPayment(tenantPayment);

    result != 0 ? debugPrint('Success') : debugPrint('Fail');
  }

  void removeTPayment(TenantPayment tPay) async {
    int? result =  await DatabaseHelper.databaseHelper.deleteTPayment(tPay.id);

    if(result != 0){
        showSnackBar(context, 'Payment Removed');
    }
  }

  void showSnackBar(BuildContext context, String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateTPaymentListView(){
    final Future<Database> dbFuture = DatabaseHelper.databaseHelper.initializeDatabase();

    dbFuture.then((database){
      Future<List<TenantPayment>> tPaymentListFuture = DatabaseHelper.databaseHelper.getTPaymentList();
      tPaymentListFuture.then((tPayments){
        if(mounted) {
          setState(() {
            tPayment = tPayments;
            //debugPrint('${(count)}');
            if (tPayment.isEmpty) {
              saveTPayment(TenantPayment(id: null,
                  paymentName: 'Rental Fee',
                  amount: null,
                  isPayed: 0));
            }
          });
        }
      });
    });
  }

  void route(TenantPayment tPay) async{
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return EditDeleteTenantPayment(tenantPayment: tPay);
        })
    );

    debugPrint('$result');
    if(result){
      updateTPaymentListView();

      for (int i = tPaymentController.length < tPayment.length ? tPaymentController.length : 0; i < tPayment.length; i++) {
        tPaymentController.add(TextEditingController(
          text: tPayment[i].amount == 0 ? null : tPayment[i].amount.toString(),
        ));
      }
    }
  }

  @override
  void initState(){
    super.initState();
    updateTPaymentListView();
  }

  @override
  Widget build(BuildContext context) {

    updateTPaymentListView();

    for (int i = tPaymentController.length < tPayment.length ? tPaymentController.length : 0; i < tPayment.length; i++) {
      tPaymentController.add(TextEditingController(
        text: tPayment[i].amount == 0 ? null : tPayment[i].amount.toString(),
      ));
    }

    return Container(
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: tPayment.length + 1, // Add 1 for the ElevatedButton
              itemBuilder: (BuildContext context, int position) {
                if (position < tPayment.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                    child: ListTile(
                      title: TextField(
                        controller: tPaymentController[position],
                        enabled: false,
                        style: Theme.of(context).textTheme.titleSmall,
                        onChanged: (value) {
                          setState(() {
                            tPayment[position].amount = int.tryParse(value) ?? 0;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: tPayment[position].paymentName,
                          labelStyle: Theme.of(context).textTheme.titleSmall,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              route(tPayment[position]);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              removeTPayment(tPayment[position]);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Render the ElevatedButton as the last item
                  return const AddPayment(indicator: 'T');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
