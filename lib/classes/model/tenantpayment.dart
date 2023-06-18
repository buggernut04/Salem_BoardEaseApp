import 'package:boardease_application/classes/model/payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../database/databasehelper.dart';

class TenantPayment extends Payment{

  int isPayed; // 0 - not payed and 1 - payed

  TenantPayment({required id, required paymentName, required amount, required this.isPayed}) : super (id: id, paymentName: paymentName, amount: amount);

  void saveTPayment() async {
    int? result;

    if(id != null){
      result = await DatabaseHelper.databaseHelper.updateTPayment(this);
    } else{
      result = await DatabaseHelper.databaseHelper.insertTPayment(this);
    }

    result != 0 ? debugPrint('Success') : debugPrint('Fail');
  }

  void showSnackBar(BuildContext context, String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void removeTPayment(BuildContext context) async {
    int? result =  await DatabaseHelper.databaseHelper.deleteTPayment(id);

    if(result != 0){
      showSnackBar(context, 'Payment Removed');
    }
  }

  // Convert a TenantPayment object into a Map Object
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'paymentName': paymentName,
      'amount': amount,
      'isPayed': isPayed,
    };
  }

  // Extract a TenantPayment Object from a Map object
  factory TenantPayment.fromMapObject(Map<String, dynamic> json) => TenantPayment(
    id: json['id'],
    paymentName: json['paymentName'],
    amount: json['amount'],
    isPayed: json['isPayed'],
  );

  /*@override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TenantPayment && runtimeType == other.runtimeType && paymentName == other.paymentName;

  @override
  int get hashCode => id.hashCode ^ paymentName.hashCode;*/
}