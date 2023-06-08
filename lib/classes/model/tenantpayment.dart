import 'package:boardease_application/classes/model/payment.dart';

class TenantPayment extends Payment{

  int isPayed; // 0 - not payed and 1 - payed

  TenantPayment({required id, required paymentName, required amount, required this.isPayed}) : super (id: id, paymentName: paymentName, amount: amount);

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
}