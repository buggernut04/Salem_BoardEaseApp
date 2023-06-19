import 'package:boardease_application/notification_service/popup_notification.dart';
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
  TextEditingController currentDateController = TextEditingController();
  int indicator = 0;

  bool isPressed = false;

  final _paymentStatus = ['Paid', 'Not Paid'];

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
            if (widget.tenant.tenantPayment.length <= tPayments.length) {
              widget.tenant.tenantPayment.addAll(tPayments.sublist(widget.tenant.tenantPayment.length));
            } else {
              int i = 0;
              while (i < tPayments.length) {
                if (tPayments[i].paymentName != widget.tenant.tenantPayment[i].paymentName) {
                  widget.tenant.tenantPayment.removeAt(i);
                } else {
                  i++;
                }
              }
              widget.tenant.tenantPayment.removeRange(i, widget.tenant.tenantPayment.length);
            }
          });
        }
      });
    });
  }

  void initializeToInputPaymentStatus(){
    for (int i = pValues.length; i < widget.tenant.tenantPayment.length; i++) {
      pValues.add(getStatusAsString(widget.tenant.tenantPayment[i].isPayed));
    }
  }

  void saveTenantStatus() async {

    for(var payment in widget.tenant.tenantPayment){
      if(payment.isPayed == 1){
        indicator++;
      }
    }

    debugPrint('$indicator');
    indicator == widget.tenant.tenantPayment.length? widget.tenant.status = 1 : indicator == 0 ? widget.tenant.status = 3 : widget.tenant.status = 2;

    widget.tenant.updateStatusAndDate();

    await DatabaseHelper.databaseHelper.updateTenant(widget.tenant);
  }

  @override
  Widget build(BuildContext context) {

    currentDateController.text = DateFormat.yMMMd().format(widget.tenant.currentDate);

    initializeToInputPaymentStatus();

    return WillPopScope(
      onWillPop: () async {
        if (isPressed) {
          PopUpNotification.cancelInfo(context);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          backgroundColor: Colors.blue[300],
          appBar: AppBar(
            title: const Text(
              'BoardEase',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black54,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue[300],
            elevation: 1.0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                if(isPressed){
                  PopUpNotification.cancelInfo(context);
                } else{
                  Navigator.pop(context, false);
                }
              },
            ),
          ),
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 20.0, right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Expanded(
                        child: Text(
                          widget.tenant.name,
                          style: const TextStyle(
                            fontSize: 23.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                     Text(
                        widget.tenant.getStatus(),
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          color: widget.tenant.getStatusColor(),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(thickness: 8.0,),

                Center(
                  child: Text(
                    'PAYMENT IS UNTIL',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: TextField(
                    controller: currentDateController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.w600
                    ),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,

                        )
                    ),
                    enabled: false,
                  )
                ),

                const Divider(thickness: 8.0,),

                Expanded(
                    child: ListView.builder(
                          itemCount: widget.tenant.tenantPayment.length  + 1,
                          itemBuilder: (BuildContext context, int position){

                            if(position < widget.tenant.tenantPayment.length) {
                              return Column(
                                children: <Widget>[

                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      (widget.tenant.tenantPayment[position]
                                          .paymentName),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Colors.indigo
                                      ),
                                    ),
                                  ),

                                  ListTile(
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

                                          isPressed = true;
                                        });
                                      },
                                      dropdownColor: Colors.white,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 36,
                                      isExpanded: true,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 19,
                                      ),
                                    ),
                                  ),

                                  const Divider(thickness: 3.0,),
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
                                            onPressed: widget.tenant.status == 1 || !isPressed ? null : () {
                                              saveTenantStatus();
                                              PopUpNotification.saveInfo(context, 3);
                                            },
                                            child: const Text(
                                              'Save',
                                              textScaleFactor: 1.5,
                                              style: TextStyle(
                                                  color: Colors.blue
                                              ),
                                            ),
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
                                              if(isPressed){
                                                PopUpNotification.cancelInfo(context);
                                              } else{
                                                Navigator.pop(context,false);
                                              }
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
      ),
    );
  }

  String getStatusAsString(int value){
    String priority = value == 1 ?  _paymentStatus[0] : _paymentStatus[1];

    return priority;
  }

  int updateStatus(String? value){
    return value == 'Paid' ? 1 : 0;
  }
}
