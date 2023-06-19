import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import '../classes/model/tenant.dart';
import 'notification_api.dart';

  Future<void> getTenantNotificationWhenAlmostDue(Tenant tenantWithNearestDate) async {
    debugPrint("Ive been here");

    //will notify in three days if there are tenants who still are not paid yet
    tenantWithNearestDate.currentDate.day - 3;

    await NotificationService.showNotification(
      title: 'BoardEase Important Notification',
      body: 'There are information about your tenants!!!',
      payload: {
        "navigate": "true",
      },
      notificationCalendar: (tenantWithNearestDate.currentDate.month <= DateTime.now().month && tenantWithNearestDate.currentDate.day < DateTime.now().day) ? DateTime.now() : tenantWithNearestDate.currentDate,
      actionButtons: [
        NotificationActionButton(
          key: 'check',
          label: 'Check it out',
          color: Colors.blue,
        )
      ],
      scheduled: true,
    );
  }

  Future<void> getTenantNotificationWhenDue(Tenant tenantWithNearestDate) async {
    debugPrint("Ive been here");

    await NotificationService.showNotification(
      title: 'BoardEase Important Notification',
      body: 'Click to see ${tenantWithNearestDate.name}',
      payload: {
        "navigate": "true",
      },
      notificationCalendar: (tenantWithNearestDate.currentDate.month <= DateTime.now().month && tenantWithNearestDate.currentDate.day < DateTime.now().day) ? DateTime.now() : tenantWithNearestDate.currentDate,
      actionButtons: [
        NotificationActionButton(
          key: 'check',
          label: 'Check it out',
          color: Colors.blue,
        )
      ],
      scheduled: true,
    );
  }

  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }
