import 'package:boardease_application/classes/tenant.dart';
import 'package:boardease_application/classes/tenantpayment.dart';

class PaymentTracker{

  List<Tenant> tenants;
  TenantPayment payment;

  PaymentTracker({required this.tenants, required this.payment});
}