import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import '../classes/model/tenant.dart';
import 'notification_api.dart';

Future<void> getTenantNotification(Tenant tenantWithNearestDate) async {

  debugPrint("Ive been here");

  await NotificationService.showNotification(
      title: 'BoardEase Important Notification',
      body: 'Click to see ${tenantWithNearestDate.name}',
      notificationCalendar: NotificationCalendar(
          month: tenantWithNearestDate.currentDate.month,
          weekday: tenantWithNearestDate.currentDate.day - 3,
          hour: tenantWithNearestDate.currentDate.hour,
          minute: tenantWithNearestDate.currentDate.minute,
          second: 0,
          millisecond: 0,
          repeats: true,
      ),
      actionType: ActionType.SilentAction,
  );
}

