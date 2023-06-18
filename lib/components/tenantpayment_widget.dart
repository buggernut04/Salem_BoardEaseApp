import 'package:boardease_application/classes/model/tenantpaymentlist.dart';
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

  TPaymentList tPayment = TPaymentList(tPayments: []);
  List<TextEditingController> tPaymentController = [];

  void updateTPaymentListView(){
    final Future<Database> dbFuture = DatabaseHelper.databaseHelper.initializeDatabase();

    dbFuture.then((database){
      Future<List<TenantPayment>> tPaymentListFuture = DatabaseHelper.databaseHelper.getTPaymentList();
      tPaymentListFuture.then((tPayments){
        if(mounted) {
          setState(() {
            tPayment.tPayments = tPayments;

            if (tPayment.tPayments.isEmpty) {
              TenantPayment tPayment = TenantPayment(id: null,
                  paymentName: 'Rental Fee',
                  amount: null,
                  isPayed: 0);

              tPayment.saveTPayment();
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

    for (int i = tPaymentController.length < tPayment.tPayments.length ? tPaymentController.length : 0; i < tPayment.tPayments.length; i++) {
      tPaymentController.add(TextEditingController(
        text: tPayment.tPayments[i].amount == 0 ? null : tPayment.tPayments[i].amount.toString(),
      ));
    }

    return Container(
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 17.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[

               Text(
                  'Tenant Fees',
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),

                AddPayment(indicator: 'T'),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: tPayment.tPayments.length, // Add 1 for the ElevatedButton
              itemBuilder: (BuildContext context, int position) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                    child: ListTile(
                      title: TextField(
                        controller: tPaymentController[position],
                        enabled: false,
                        style: Theme.of(context).textTheme.titleSmall,
                        onChanged: (value) {
                          setState(() {
                            tPayment.tPayments[position].amount = int.tryParse(value) ?? 0;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: tPayment.tPayments[position].paymentName,
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
                              route(tPayment.tPayments[position]);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              tPayment.tPayments[position].removeTPayment(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
              },
            ),
          ),
        ],
      ),
    );
  }
}
