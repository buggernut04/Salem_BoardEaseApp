import 'package:boardease_application/classes/paymentstatus.dart';

class Tenant{

  int? id;
  String name;
  String contactInfo;
  PaymentStatus status;
  DateTime startDate;

  Tenant(this.name, this.contactInfo,this.status, this.startDate);

  Tenant.withId(this.name, this.contactInfo,this.status, this.startDate);

  int? get getId => id;

  String get getName => name;

  String get getContactInfo => contactInfo;

  // mas better talig e int ang status
  PaymentStatus get getStatus => status;

  DateTime get getStartingDate => startDate;

  // setters

}