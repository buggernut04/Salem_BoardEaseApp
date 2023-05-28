class Payment{

  int? rentalFee;
  int? birFee;
  int waterConsumption;
  int electricConsumption;
  DateTime? paymentDate;

  Payment(this.rentalFee, this.waterConsumption, this.electricConsumption, this.paymentDate, [this.birFee]);

  Payment.withOnlyWaterAndElectricConsumption(this.waterConsumption,this.electricConsumption);
}