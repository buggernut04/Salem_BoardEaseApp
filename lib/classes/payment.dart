abstract class Payment{

  int amount;
  DateTime? paymentDate;

  Payment(this.amount, this.paymentDate);

  Payment.onlyAmount(this.amount);
}