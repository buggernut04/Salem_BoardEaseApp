import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes/model/tenant.dart';
import 'notification_api.dart';

  Future<void> getTenantNotification(Tenant tenantWithNearestDate) async {
    debugPrint("Ive been here");

    await NotificationService.showNotification(
      title: 'BoardEase Important Notification',
      body: 'Click to see ${tenantWithNearestDate.name}',
      payload: {
        "navigate": "true",
      },
      notificationCalendar: tenantWithNearestDate.currentDate,
      actionButtons: [
        NotificationActionButton(
          key: 'check',
          label: 'Check it out',
          actionType: ActionType.SilentAction,
          color: Colors.green,
        )
      ],
      scheduled: true,
  );

}
