import 'package:boardease_application/classes/payment.dart';

class OwnerPayment extends Payment{

  int brgyFee;

  OwnerPayment({required this.brgyFee, required waterConsumption, required electricConsumption, required paymentDate}) : super(waterConsumption: waterConsumption, electricConsumption: electricConsumption, paymentDate: paymentDate);
}