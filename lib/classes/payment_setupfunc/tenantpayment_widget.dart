import 'package:boardease_application/inputDetails/editdeletetenantpayment.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../database/databasehelper.dart';
import '../../inputDetails/addpayment.dart';
import '../model/tenantpayment.dart';

class TenantPaymentWidget extends StatefulWidget {
  const TenantPaymentWidget({Key? key}) : super(key: key);

  @override
  State<TenantPaymentWidget> createState() => _TenantPaymentWidgetState();
}

class _TenantPaymentWidgetState extends State<TenantPaymentWidget> {
  int count = 0 ;
  List<TenantPayment> tPayment = [];

  List<TextEditingController> tPaymentController = [];

  void saveTPayment(TenantPayment tenantPayment) async {
    int? result;

    result = await DatabaseHelper.databaseHelper.insertTPayment(tenantPayment);

    result != 0 ? debugPrint('Success') : debugPrint('Fail');
  }

  void removeTPayment(TenantPayment tPay) async {
    await DatabaseHelper.databaseHelper.deleteTPayment(tPay.id);
  }

  void updateTPaymentListView(){
    final Future<Database> dbFuture = DatabaseHelper.databaseHelper.initializeDatabase();

    dbFuture.then((database){
      Future<List<TenantPayment>> tPaymentListFuture = DatabaseHelper.databaseHelper.getTPaymentList();
      tPaymentListFuture.then((tPayments){
        if(mounted) {
          setState(() {
            tPayment = tPayments;
            count = tPayments.length;

            //debugPrint('${(count)}');
            if (count == 0) {
              saveTPayment(TenantPayment(id: null,
                  paymentName: 'Rental Fee',
                  amount: 0,
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

    if(result){
      updateTPaymentListView();
    }
  }

  @override
  Widget build(BuildContext context) {

    updateTPaymentListView();

    return Container(
      padding: EdgeInsets.zero,
      child: tenantPayment(),
    );
  }

  Widget tenantPayment(){

    if (tPaymentController.length < count) {
      for (int i = tPaymentController.length; i < count; i++) {
        tPaymentController.add(TextEditingController(
          text: tPayment[i].amount.toString(),
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
    );
  }
}
