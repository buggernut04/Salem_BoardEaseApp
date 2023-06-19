import 'package:flutter/material.dart';

import '../classes/model/tenantpayment.dart';
import '../notification_service/popup_notification.dart';


class EditDeleteTenantPayment extends StatefulWidget {
  const EditDeleteTenantPayment({Key? key, required this.tenantPayment}) : super(key: key);

  final TenantPayment tenantPayment;

  @override
  State<EditDeleteTenantPayment> createState() => _EditDeleteTenantPaymentState();
}

class _EditDeleteTenantPaymentState extends State<EditDeleteTenantPayment> {

  final formKey = GlobalKey<FormState>();
  TextEditingController pName = TextEditingController();
  TextEditingController amount = TextEditingController();

  bool isFormEdited = false;

  @override
  void initState(){
    super.initState();
    pName.text = widget.tenantPayment.paymentName;
    amount.text = widget.tenantPayment.amount.toString();
  }

  bool validateInput(String input) {
    RegExp regex = RegExp(r'^\d+$');
    return regex.hasMatch(input) && input.length < 5;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        if (isFormEdited) {
          PopUpNotification.cancelInfo(context);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'BoardEase',
            style: TextStyle(
              fontSize: 25,
              color: Colors.black54,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[300],
          elevation: 1.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              if(isFormEdited){
                PopUpNotification.cancelInfo(context);
              }else {
                Navigator.pop(context, false);
              }
            },
          ),
        ),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Center(
                  child:  Text(
                    '${widget.tenantPayment.paymentName} Payment',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.cyan,
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),

              Expanded(
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                      child: ListView(
                        children: <Widget>[

                          Container(
                            padding: const EdgeInsets.symmetric(vertical:10, horizontal: 10),
                            child: TextFormField(
                              controller: pName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Payment Name',
                              ),
                              onChanged: (value){
                                widget.tenantPayment.paymentName = pName.text;

                                setState(() {
                                  isFormEdited = true;
                                });
                              },
                              enabled: !(widget.tenantPayment.paymentName == 'Rental Fee'),
                              validator: (value){
                                if (value!.isEmpty) {
                                  return 'Please enter a payment';
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 10.0),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              controller: amount,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Amount',
                              ),
                              onChanged: (value){
                                widget.tenantPayment.amount = int.tryParse(amount.text) ?? 0;

                                setState(() {
                                  isFormEdited = true;
                                });
                              },
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
                              onPressed: isFormEdited ? () {
                                if (formKey.currentState!.validate()){
                                  widget.tenantPayment.saveTPayment();
                                  PopUpNotification.saveInfo(context, 5);
                                }
                              } : null,
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
                                if(isFormEdited){
                                  PopUpNotification.cancelInfo(context);
                                } else{
                                  Navigator.pop(context,false);
                                }
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
                  )
                ),
            ],
          ),
        ),
      ),
    );
  }
}