import 'package:flutter/material.dart';

import '../classes/model/tenantpayment.dart';


class EditDeleteTenantPayment extends StatefulWidget {
  const EditDeleteTenantPayment({Key? key, required this.tenantPayment}) : super(key: key);

  final TenantPayment tenantPayment;

  @override
  State<EditDeleteTenantPayment> createState() => _EditDeleteTenantPaymentState();
}

class _EditDeleteTenantPaymentState extends State<EditDeleteTenantPayment> {

  TextEditingController pName = TextEditingController();
  TextEditingController amount = TextEditingController();

  @override
  Widget build(BuildContext context) {

    pName.text = widget.tenantPayment.paymentName;
    amount.text = widget.tenantPayment.amount.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tenantPayment.paymentName),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Container(
            padding: const EdgeInsets.symmetric(vertical:10, horizontal: 10),
            child: TextField(
              controller: pName,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Payment Name',
              ),
              onChanged: (value){
                widget.tenantPayment.paymentName = pName.text;
              },
            ),
          ),

          const SizedBox(height: 10.0),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: amount,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Amount',
              ),
              onChanged: (value){
                  widget.tenantPayment.amount = int.tryParse(amount.text) ?? 0;
              },
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.tenantPayment.saveTPayment();
                Navigator.of(context).pop(true);
              },
              child: const Text(
                'SAVE',
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
                Navigator.of(context).pop(false); // Close the dialog
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
    );
  }
}