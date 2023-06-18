import 'package:boardease_application/classes/model/tenant.dart';
import 'package:flutter/material.dart';

import '../../notification_service/notification_body.dart';

class TenantList{

  List<Tenant> tenant;

  TenantList({required this.tenant});

  List<Tenant> getPaidTenants() {
    return tenant.where((tenant) => tenant.status == 1).toList();
  }

  List<Tenant> getNFPaidTenants() {
    return tenant.where((tenant) => tenant.status == 2).toList();
  }

  List<Tenant> getNotPaidTenants() {
    return tenant.where((tenant) => tenant.status == 3).toList();
  }

  List<Tenant> getTenantsDueInThreeDays(){
    return tenant.where((tenant) => tenant.isPaymentDueThreeDays() == true).toList();
  }

  int getTenantsDueToday(){
    int count = 0;

    for (var tenants in tenant) {
      if (tenants.isPaymentDue()) {
        tenants.changeStatusWhenPaidAndNotPaid(); // Change the value of the specific tenant
        count++;
      }
    }

    return count;
  }

  bool checkIfNameExists(String name) {
    String lowerCaseName = name.toLowerCase();

    return tenant.any((tenants) => tenants.name.toLowerCase() == lowerCaseName);
  }

  bool checkIfPhoneNumberExists(String phoneNumber) {
    final normalizedPhoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    return tenant.any((tenants) => tenants.contactInfo == normalizedPhoneNumber);
  }

  Icon setIcon(){
    //debugPrint('${(getTenantsDueToday())}');
    return getTenantsDueInThreeDays().isNotEmpty ||  getTenantsDueToday() != 0 ? const Icon(Icons.notifications_active, color: Colors.red) : const Icon(Icons.notifications_none);
  }


  void getTenantForNotification(){

    if (tenant.isEmpty) {
      return;
    }

    Tenant tenantWithNearestDate = tenant.reduce((a, b) =>
    (DateTime.parse(a.currentDate.toString()).difference(DateTime.now()).abs() <
        DateTime.parse(b.currentDate.toString()).difference(DateTime.now()).abs())
        ? a
        : b);

    debugPrint("${tenantWithNearestDate.currentDate.month} + ${tenantWithNearestDate.currentDate.day - 3} + ${tenantWithNearestDate.name}");

    getTenantNotificationWhenAlmostDue(tenantWithNearestDate);
    getTenantNotificationWhenDue(tenantWithNearestDate);
  }
}