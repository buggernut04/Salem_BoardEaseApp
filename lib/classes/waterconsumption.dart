import 'package:boardease_application/classes/payment.dart';

class WaterConsumptionPayment extends Payment{

  WaterConsumptionPayment(int amount, DateTime paymentDate) : super(amount, paymentDate);

  WaterConsumptionPayment.onlyAmount(int amount, [DateTime? paymentDate]) : super(amount, paymentDate);
}