import '../../database/databasehelper.dart';

class NotificationBody{

  int? id;
  String body;
  DateTime timeCreated;

  NotificationBody({this.id, required this.body, required this.timeCreated});

  void saveNotification() async {
    int? result;

    result = await DatabaseHelper.databaseHelper.insertNotifications(this);

    result != 0 ? print('Success') : print('Fail');
  }

  void removeNotification() async {
    int? result = await DatabaseHelper.databaseHelper.deleteNotification(id);

    result != 0 ? print('Success') : print('Fail');
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'body': body,
      'timeCreated': timeCreated.toIso8601String(),
    };
  }

  // Extract a Tenant Object from a Map object
  factory NotificationBody.fromMapObject(Map<String, dynamic> json) => NotificationBody(
    id: json['id'],
    body: json['body'],
    timeCreated: DateTime.parse(json['timeCreated']),
  );
}