import 'dart:convert';

import 'package:boardease_application/classes/model/tenantpayment.dart';

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
    return (status == 2 || status == 3) && daysRemaining <= 3 && daysRemaining >= 1;
  }

  bool isPaymentDue() {
    final daysRemaining = currentDate.difference(DateTime.now()).inDays;
    return (status == 2 || status == 3) && daysRemaining <= 0;
  }

  void changeStatus(){
    if(isPaymentDue() && (status == 1 || status == 2)){
      for (var payment in tenantPayment) {
        payment.isPayed = 0;
      }
      status = 3;
    }
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