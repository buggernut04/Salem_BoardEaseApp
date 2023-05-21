import 'package:boardease_application/classes/tenantpayment.dart';
import 'ownerPayment.dart';

class PaymentHolder{

  List<OwnerPayment>? ownerPayments;
  List<TenantPayment>? tenantPayments;

  PaymentHolder.fromOwnerPayments({required this.ownerPayments});

  PaymentHolder.fromTenantPayments({required this.tenantPayments});

}