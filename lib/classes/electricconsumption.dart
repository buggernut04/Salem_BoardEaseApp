import 'package:boardease_application/classes/payment.dart';

class ElectricConsumptionPayment extends Payment{

  ElectricConsumptionPayment(int amount, DateTime paymentDate) : super(amount, paymentDate);

  ElectricConsumptionPayment.onlyAmount(int amount, [DateTime? paymentDate]) : super(amount, paymentDate);
}