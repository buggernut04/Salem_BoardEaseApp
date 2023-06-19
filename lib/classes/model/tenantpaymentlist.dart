import 'package:boardease_application/classes/model/tenantpayment.dart';

class TPaymentList{

  List<TenantPayment> tPayments;

  TPaymentList({required this.tPayments});

  bool checkIfPaymentNameExists(String name) {
    String lowerCaseName = name.toLowerCase();

    return tPayments.any((tPayment) => tPayment.paymentName.toLowerCase() == lowerCaseName);
  }

}