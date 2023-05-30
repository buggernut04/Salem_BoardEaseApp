import 'package:boardease_application/classes/payment.dart';

class RentalFeePayment extends Payment{

  RentalFeePayment(int amount, DateTime paymentDate) : super(amount, paymentDate);

  RentalFeePayment.onlyAmount(int amount, [DateTime? paymentDate]) : super(amount, paymentDate);
}