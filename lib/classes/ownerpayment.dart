import 'package:boardease_application/classes/payment.dart';

class OwnerPayment extends Payment{

  DateTime datePayed;

  OwnerPayment({required id, required paymentName, required amount, required this.datePayed}) : super (id: id, paymentName: paymentName, amount: amount);

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
}