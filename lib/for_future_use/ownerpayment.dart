/*
import 'package:boardease_application/classes/model/payment.dart';
import 'package:flutter/cupertino.dart';

import '../database/databasehelper.dart';

class OwnerPayment extends Payment{

  DateTime datePayed;

  OwnerPayment({required id, required paymentName, required amount, required this.datePayed}) : super (id: id, paymentName: paymentName, amount: amount);

  void saveWPayment() async {
    int? result;

    if(id != null){
      result = await DatabaseHelper.databaseHelper.updateWPayment(this);
    } else{
      result = await DatabaseHelper.databaseHelper.insertWPayment(this);
    }

    result != 0 ? debugPrint('Success') : debugPrint('Fail');
  }


  // Convert a OwnerPayment object into a Map Object
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'paymentName': paymentName,
      'amount': amount,
      'datePayed': datePayed.toIso8601String(),
    };
  }

  // Extract a OwnerPayment Object from a Map object
  factory OwnerPayment.fromMapObject(Map<String, dynamic> json) => OwnerPayment(
    id: json['id'],
    paymentName: json['paymentName'],
    amount: json['amount'],
    datePayed: DateTime.parse(json['datePayed']),
  );
}*/
