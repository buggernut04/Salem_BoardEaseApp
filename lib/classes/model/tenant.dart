import 'dart:convert';

import 'package:boardease_application/classes/model/tenantpayment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../database/databasehelper.dart';

class Tenant{

  int? id;
  String name;
  String contactInfo;
  int status;
  DateTime startDate;
  DateTime currentDate;
  List<TenantPayment> tenantPayment;

  Tenant({this.id, required this.name, required this.contactInfo,required this.status, required this.startDate, required this.currentDate, required this.tenantPayment});

  void updateStatusAndDate() {
    if (status == 1) {
      currentDate = getNextMonth(currentDate);
      status = 1;
    }
  }

  DateTime getNextMonth(DateTime date) {
    final nextMonth = date.month < 12 ? date.month + 1 : 1;
    final nextYear = date.month < 12 ? date.year : date.year + 1;
    return DateTime(nextYear, nextMonth, date.day, date.hour, date.minute, date.second, date.millisecond,
        date.microsecond);
  }

  bool isPaymentDueThreeDays() {
    final daysRemaining = currentDate.difference(DateTime.now()).inDays;
    return daysRemaining <= 3 && daysRemaining >= 1;
  }

  bool isPaymentDue() {
    final daysRemaining = currentDate.difference(DateTime.now()).inDays;
    return daysRemaining <= 0;
  }

  void changeStatusWhenPaidAndNotPaid(){
    if(isPaymentDue() && (status == 1 || status == 2)){
      for (var payment in tenantPayment) {
        payment.isPayed = 0;
      }
      status = 3;
    }
  }

  String getStatus(){
    if(status == 1){
      return 'Payed';
    }
    else if(status == 2){
      return 'Not Fully Payed';
    }
    else{
      return 'Not Payed';
    }
  }

  // every status has its own color
  Color getStatusColor(){
    if(status == 1){
      return Colors.yellow;
    }
    else if(status == 2){
      return Colors.greenAccent;
    }
    else{
      return Colors.red;
    }
  }


  // save the tenant to the database
  void saveTenant() async {
    int? result;

    if(id != null){
      result = await DatabaseHelper.databaseHelper.updateTenant(this);
    } else{
      // If when the tenant will start to live, that is also the day he will start his/her payment.
      // Base on my stakeholder advise
      currentDate = startDate;

      result = await DatabaseHelper.databaseHelper.insertTenant(this);
    }

    result != 0 ? print('Success') : print('Fail');
  }

  // remove a tenant
  // improve
  void removeTenant(BuildContext context) async {
    int? result = await DatabaseHelper.databaseHelper.deleteTenant(id);

    if(result != 0){
      showSnackBar(context, 'Tenant Removed');
    }
  }

  void showSnackBar(BuildContext context, String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Convert a Tenant object into a Map Object
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'contactInfo': contactInfo,
      'startDate': startDate.toIso8601String(),
      'currentDate': currentDate.toIso8601String(),
      'status': status,
      'tenantPayment': jsonEncode(tenantPayment.map((payment) => payment.toMap()).toList()),
    };
  }

  // Extract a Tenant Object from a Map object
  factory Tenant.fromMapObject(Map<String, dynamic> json) => Tenant(
      id: json['id'],
      name: json['name'],
      contactInfo: json['contactInfo'],
      startDate: DateTime.parse(json['startDate']),
      currentDate: DateTime.parse(json['currentDate']),
      status: json['status'],
      tenantPayment: List<TenantPayment>.from(
      jsonDecode(json['tenantPayment']).map((paymentJson) => TenantPayment.fromMapObject(paymentJson))),
    );
}