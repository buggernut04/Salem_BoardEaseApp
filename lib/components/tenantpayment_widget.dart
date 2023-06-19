import 'package:boardease_application/classes/model/tenantpaymentlist.dart';
import 'package:boardease_application/inputDetails/edittenantpayment.dart';
import 'package:boardease_application/notification_service/popup_notification.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                  amount: 0,
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

    return Container(
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 17.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                const Text(
                  'Tenant Fees',
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),

               AddPayment(tPaymentList: tPayment),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: tPayment.tPayments.length, // Add 1 for the ElevatedButton
              itemBuilder: (BuildContext context, int position) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Card(
                      child: ListTile(
                        title: Text(
                          tPayment.tPayments[position].paymentName,
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            )
                        ),
                        subtitle: Text(
                            NumberFormat.currency(symbol: '₱').format( tPayment.tPayments[position].amount),
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            )
                        ),
                        leading: const Icon(Icons.payment_rounded,color: Colors.black,),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: position != 0 ? const Icon(Icons.edit,color: Colors.black54,) : const SizedBox(),
                              onPressed: () {
                                route(tPayment.tPayments[position]);
                              },
                            ),
                            IconButton(
                              icon: position != 0 ? const Icon(Icons.delete,color: Colors.redAccent) : const Icon(Icons.edit,color: Colors.black54,),
                              onPressed:(){
                                position != 0 ? PopUpNotification.removePaymentInfo(context, tPayment.tPayments[position]) : route(tPayment.tPayments[position]);
                              },
                            ),
                          ],
                        ),
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
