import 'package:boardease_application/classes/paymentstatus.dart';
import 'package:boardease_application/classes/person.dart';

class Tenant extends Person{

  PaymentStatus status;
  DateTime startDate;

  Tenant({required name, required contactInfo, required email, required this.status, required this.startDate}) : super(name: name, contactInfo: contactInfo, email: email);
}