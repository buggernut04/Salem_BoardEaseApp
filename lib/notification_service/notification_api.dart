import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:boardease_application/components/root_app.dart';
import 'package:boardease_application/main.dart';
import 'package:flutter/material.dart';

class NotificationService {

  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/res_notif_logo',
      [
        NotificationChannel(
          channelKey: 'high_importance_channel',
          channelName: 'BoardEase App',
          channelDescription: 'Notification channel for basic tests',
          channelGroupKey: 'high_importance_channel',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel_group',
          channelGroupName: 'Group 1',
        )
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
          (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      /*ReceivedAction receivedAction) async {
        debugPrint('onActionReceivedMethod');
        final payload = receivedAction.payload ?? {};
        if (payload["navigate"] == "true") {
          BoardEaseApp.navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (_) => const Notifications(),
            ),
          );
        }*/
      ReceivedAction receivedAction) async {
      debugPrint('onActionReceivedMethod');
      final payload = receivedAction.payload ?? {};
      if (payload["navigate"] == "true") {
        BoardEaseApp.navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => const RootApp(),
          ),
        );
      }
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final DateTime? notificationCalendar,
    final ActionType actionType = ActionType.Default,
    final Map<String, String>? payload,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    //final int? interval,
  }) async {
    assert(!scheduled || (scheduled && notificationCalendar != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        actionType: actionType,
        payload: payload,
        notificationLayout: notificationLayout,
        wakeUpScreen: true,
      ),
      actionButtons: actionButtons,
      //notificationCalendar: notificationCalendar,
      schedule: scheduled
          ? NotificationCalendar(
        // For testing is in here
        //month: notificationCalendar.month,
       // day: notificationCalendar.day,
        //hour: notificationCalendar.hour,
        //minute: notificationCalendar.minute,
        second: notificationCalendar?.second,
        //millisecond: notificationCalendar?.millisecond,
        timeZone:
        await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        preciseAlarm: true,
      )
          : null,
      /*schedule: scheduled
          ? NotificationInterval(
        interval: interval,
        timeZone:
        await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        preciseAlarm: true,
      )
          : null,*/
      /*NotificationCalendar(
          *//*hour: 14,
          minute: 59,*//*
          minute: 2,
          second: 10,
          millisecond: 0,
          repeats: false,
      ),*/
    );
  }
}