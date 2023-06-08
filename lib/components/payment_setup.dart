import 'package:boardease_application/classes/payment_setupfunc/ownerpayment_widget.dart';
import 'package:boardease_application/classes/payment_setupfunc/tenantpayment_widget.dart';
import 'package:flutter/material.dart';

class PaymentDetail extends StatefulWidget {
  const PaymentDetail({Key? key}) : super(key: key);

  @override
  State<PaymentDetail> createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
          centerTitle: true,
          backgroundColor: Colors.blue[300],
          elevation: 0.0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TabBar(
                tabs: [
                  Tab(
                    child: Text(
                        'Tenant Payment',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[600],
                        )
                    ),
                  ),
                  Tab(
                    child: Text(
                        'Owner Payment',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[600],
                        )
                    ),
                  )
                ]
            ),
            const Expanded(
              child: TabBarView(
                  children: <Widget>[
                    TenantPaymentWidget(),
                    OwnerPaymentWidget(),
                  ]
              ),
            )
          ],
        )
      ),
    );
  }
}
