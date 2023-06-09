import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/model/tenant.dart';
import '../classes/model/tenantpayment.dart';
import '../database/databasehelper.dart';

class TenantStatus extends StatefulWidget {
  const TenantStatus({Key? key, required this.tenant}) : super(key: key);

  final Tenant tenant;

  @override
  State<TenantStatus> createState() => _TenantStatusState();
}

class _TenantStatusState extends State<TenantStatus> {

  String? mValueChoose;
  int count = 0 ;
  List<TenantPayment> tPayment = [];
  List<String?> pValues = [];

  final _months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  final _paymentStatus = ['Payed', 'Not Payed'];

  void updateTPaymentList(){
    final Future<Database> dbFuture = DatabaseHelper.databaseHelper.initializeDatabase();

    dbFuture.then((database){
      Future<List<TenantPayment>> tPaymentListFuture = DatabaseHelper.databaseHelper.getTPaymentList();
      tPaymentListFuture.then((tPayments){
        if(mounted) {
          setState(() {
            tPayment = tPayments;
            count = tPayments.length;
          });
        }
      });
    });
  }

  void saveTenantStatus(){

    int indicator = 0;

    for(int i = 0; i < tPayment.length ; i++){
      if(tPayment[i].isPayed == 1){
        indicator++;
      }
    }

    indicator == tPayment.length - 1 ? widget.tenant.status = 1 : indicator == 0 ? widget.tenant.status = 3 : widget.tenant.status = 2;
  }



  @override
  Widget build(BuildContext context) {

    if (pValues.length < count) {
      for (int i = pValues.length; i < count; i++) {
        pValues.add(_paymentStatus[1]);
      }
    }

    updateTPaymentList();

    return Scaffold(
        appBar: AppBar(
          title: Text(
            (widget.tenant.name),
            style: const TextStyle(fontSize: 23),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[300],
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Month Payed (${DateTime.now().year})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: DropdownButton(
                    items: _months.map((String dropDownStringItem) => DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    )
                    ).toList(),
                    hint: const Text('Select Month'),
                    value: mValueChoose,
                    onChanged: (newValue){
                      setState(() {
                       mValueChoose = newValue;
                      });
                    },
                    dropdownColor: Colors.white70,

                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 36,
                    isExpanded: true,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                ),
              ),

              Expanded(
                  child: ListView.builder(
                        itemCount: count,
                        itemBuilder: (BuildContext context, int position){

                          return Column(
                            children: <Widget>[

                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  (tPayment[position].paymentName),
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: DropdownButton(
                                  items: _paymentStatus.map((String dropDownStringItem) => DropdownMenuItem<String>(
                                    value: dropDownStringItem,
                                    child: Text(dropDownStringItem),
                                  )
                                  ).toList(),
                                  hint: const Text('Choose Status'),
                                  value: pValues[position],
                                  onChanged: (newValue){
                                    setState(() {
                                      //getStatusAsString(tPayment[position].isPayed);
                                      pValues[position] = newValue;
                                      tPayment[position].isPayed = updateStatus(newValue);
                                    });
                                  },
                                  dropdownColor: Colors.white70,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 36,
                                  isExpanded: true,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      )
              )

            ],
          ),
        )
      );
  }

  String getStatusAsString(int value){
    String priority = value == 1 ?  _paymentStatus[0] : _paymentStatus[1];

    return priority;
  }

  int updateStatus(String? value){
    return value == 'Payed' ? 1 : 0;
  }
}
