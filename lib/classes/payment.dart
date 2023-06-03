class Payment{

  int? id;
  String paymentName;
  int amount;
  int isPayed; // 0 - not payed : 1 - payed

  Payment({this.id, required this.paymentName, required this.amount,required this.isPayed});
}