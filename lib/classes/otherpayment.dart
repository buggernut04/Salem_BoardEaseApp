import 'package:boardease_application/classes/payment.dart';

class OtherPayment extends Payment{

  OtherPayment(int amount, DateTime paymentDate) : super(amount, paymentDate);

  OtherPayment.onlyAmount(int amount, [DateTime? paymentDate]) : super(amount, paymentDate);
}