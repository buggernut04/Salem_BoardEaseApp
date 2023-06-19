import 'package:boardease_application/classes/model/tenantpaymentlist.dart';
import 'package:boardease_application/notification_service/popup_notification.dart';
import 'package:flutter/material.dart';

import '../classes/model/tenantpayment.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({Key? key, required this.tPaymentList}) : super(key: key);

  final TPaymentList tPaymentList;

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {

  final formKey = GlobalKey<FormState>();

  TextEditingController pName = TextEditingController();
  TextEditingController amount = TextEditingController();

  @override
  void dispose(){
    super.dispose();
    pName.dispose();
    amount.dispose();
  }

  bool validateInput(String input) {
    RegExp regex = RegExp(r'^\d+$');
    return regex.hasMatch(input) && input.length < 5;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){
       openDialog();
      },
      icon: const Icon(Icons.add),
      iconSize: 30,
      highlightColor: Colors.blue,
    );
  }

  void openDialog() => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        child: SizedBox(
          height: 350,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextFormField(
                    controller: pName,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Payment Name',
                      labelText: 'Payment Name', prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value){
                      if (value!.isEmpty) {
                        return 'Please enter a payment';
                      } else if (widget.tPaymentList.checkIfPaymentNameExists(value)) {
                        return 'Payment already exist';
                      }
                      return null;
                    },
                    maxLength: 15,
                  ),
                ),

                const SizedBox(height: 10.0),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextFormField(
                    controller: amount,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Amount',
                      labelText: 'Amount',
                      prefixIcon: Icon(Icons.monetization_on),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Please enter amount';
                      } else if(!validateInput(value)){
                        return 'Invalid amount';
                      }
                      return null;
                    },
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if(formKey.currentState!.validate()){
                        TenantPayment tPayment = TenantPayment(id: null, paymentName: pName.text, amount: int.tryParse(amount.text) ?? 0, isPayed: 0);
                        tPayment.saveTPayment();

                        PopUpNotification.saveInfo(context, 4);
                      }
                    },
                    child: const Text(
                      'ADD',
                      textScaleFactor: 1.5,
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 1),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      pName.clear();
                      amount.clear();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'CANCEL',
                      textScaleFactor: 1.5,
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}