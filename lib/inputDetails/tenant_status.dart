import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  List<String?> pValues = [];
  int indicator = 0;
  //List<TenantPayment> tPayment = [];

  final _paymentStatus = ['Payed', 'Not Payed'];

  @override
  void initState() {
    super.initState();
    getUpdatedTPaymentList();
  }

  void getUpdatedTPaymentList(){
    final Future<Database> dbFuture = DatabaseHelper.databaseHelper.initializeDatabase();

    dbFuture.then((database){
      Future<List<TenantPayment>> tPaymentListFuture = DatabaseHelper.databaseHelper.getTPaymentList();
      tPaymentListFuture.then((tPayments){
        if(mounted) {
          setState(() {
            if(widget.tenant.tenantPayment.length <= tPayments.length) {
              for(int i = widget.tenant.tenantPayment.length; i <
                  tPayments.length; i++) {
                widget.tenant.tenantPayment.add(tPayments[i]);
              }
            } else{
              int i = 0, j = 0;
              while(true){
                if(tPayments[i].paymentName != widget.tenant.tenantPayment[j].paymentName){
                  widget.tenant.tenantPayment.remove(widget.tenant.tenantPayment[i]);
                  i++;
                } else{
                  i++;
                  j++;
                }
                if(i >= tPayments.length){
                  break;
                }
              }
              if(tPayments.length != widget.tenant.tenantPayment.length){
                widget.tenant.tenantPayment.remove(widget.tenant.tenantPayment[i]);
              }
            }
          });

          /*debugPrint('${(widget.tenant.tenantPayment.length)}');
          debugPrint('${(tPayments.length)}');*/
        }
      });
    });
  }

  void initializePaymentStatus(){
    for (int i = pValues.length; i < widget.tenant.tenantPayment.length; i++) {
      pValues.add(getStatusAsString(widget.tenant.tenantPayment[i].isPayed));
    }
  }

  void saveTenantStatus() async {
    indicator == widget.tenant.tenantPayment.length? widget.tenant.status = 1 : indicator == 0 ? widget.tenant.status = 3 : widget.tenant.status = 2;

    widget.tenant.updateStatusAndDate();

    await DatabaseHelper.databaseHelper.updateTenant(widget.tenant);
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController currentDateController = TextEditingController();
    currentDateController.text = DateFormat.yMMMd().format(widget.tenant.currentDate);

    initializePaymentStatus();

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
                  'Valid Until',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextField(
                  controller: currentDateController,
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                  enabled: false,
                )
              ),

              Expanded(
                  child: ListView.builder(
                        itemCount: widget.tenant.tenantPayment.length  + 1,
                        itemBuilder: (BuildContext context, int position){

                          if(position < widget.tenant.tenantPayment.length) {
                            return Column(
                              children: <Widget>[

                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    (widget.tenant.tenantPayment[position]
                                        .paymentName),
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                ),

                                Card(
                                  child: ListTile(
                                    title: DropdownButton(
                                      items: _paymentStatus.map((
                                          String dropDownStringItem) =>
                                          DropdownMenuItem<String>(
                                            value: dropDownStringItem,
                                            child: Text(dropDownStringItem),
                                          )
                                      ).toList(),
                                      hint: const Text('Choose Status'),
                                      value: pValues[position],
                                      onChanged: (newValue) {
                                        setState(() {
                                          pValues[position] = newValue;
                                          widget.tenant.tenantPayment[position]
                                              .isPayed = updateStatus(newValue);
                                          //debugPrint('${(widget.tenant.tenantPayment[position].isPayed)}');
                                          if(widget.tenant.tenantPayment[position].isPayed == 1){
                                            // put a condition in here
                                            // ibutang sa save ni nga button jud
                                            indicator++;
                                          }
                                          //await DatabaseHelper.databaseHelper.updateTenant(widget.tenant);
                                        });
                                      },
                                      dropdownColor: Colors.white,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 36,
                                      isExpanded: true,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                              return Padding(
                                padding: const EdgeInsets.only(top: 13.0, bottom: 13.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(foregroundColor: Colors.white70
                                          ),
                                          child: const Text(
                                            'Save',
                                            textScaleFactor: 1.5,
                                            style: TextStyle(
                                                color: Colors.blue
                                            ),
                                          ),
                                          onPressed: () {
                                            saveTenantStatus();
                                            Navigator.pop(context, true);
                                          },
                                        )
                                    ),

                                    Container(width: 8.0,),

                                    Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(foregroundColor: Colors.white70),
                                          child: const Text(
                                            'Cancel' ,
                                            textScaleFactor: 1.5,
                                            style: TextStyle(
                                                color: Colors.blue
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                        )
                                    )
                                  ],
                                ),
                              );
                            }
                          }
                        )
                  ),
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
