class Tenant{

  int? id;
  String name;
  String contactInfo;
  int status; // 1 -> Payed, 2 -> Not Fully Payed, 3 -> Not Payed
  DateTime startDate;

  Tenant(this.name, this.contactInfo,this.status, this.startDate);

  Tenant.withId(this.name, this.contactInfo,this.status, this.startDate);

  int? get getId => id;

  String get getName => name;

  String get getContactInfo => contactInfo;

  // mas better talig e int ang status
  int get getStatus => status;

  DateTime get getStartingDate => startDate;

  // setters
  set setName(String newName){
    this.name = newName;
  }

  set setContactInfo(String newContact){
    this.contactInfo = newContact;
  }

  set setDate(DateTime newDate){
    this.startDate = newDate;
  }

  set setStatus(int newStatus){
    newStatus >= 1 && newStatus <= 3 ? status = newStatus : status = status;
  }

}