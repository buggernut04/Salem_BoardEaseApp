import 'package:boardease_application/classes/payment.dart';

class TenantPayment extends Payment{

  int rentalFee;

  TenantPayment({required this.rentalFee, required waterConsumption, required electricConsumption, required paymentDate}) : super(waterConsumption: waterConsumption, electricConsumption: electricConsumption, paymentDate: paymentDate);
}