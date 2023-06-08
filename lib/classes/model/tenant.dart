class Tenant{

  int? id;
  String name;
  String contactInfo;
  int status;
  DateTime startDate;
  DateTime currentDate;

  Tenant({this.id, required this.name, required this.contactInfo,required this.status, required this.startDate, required this.currentDate});


  // Convert a Tenant object into a Map Object
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'contactInfo': contactInfo,
      'startDate': startDate.toIso8601String(),
      'currentDate': currentDate.toIso8601String(),
      'status': status,
    };
  }

  // Extract a Tenant Object from a Map object
  factory Tenant.fromMapObject(Map<String, dynamic> json) => Tenant(
      id: json['id'],
      name: json['name'],
      contactInfo: json['contactInfo'],
      startDate: DateTime.parse(json['startDate']),
      currentDate: DateTime.parse(json['currentDate']),
      status: json['status'],
    );
}