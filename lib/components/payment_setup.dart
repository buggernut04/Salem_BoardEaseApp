import 'package:boardease_application/pages/ownerpayment_widget.dart';
import 'package:boardease_application/pages/tenantpayment_widget.dart';
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
          backgroundColor: Colors.blue[300],
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
          ),
          body: Container(
            height: 800,
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
            ),
          )
       ),
    );
  }
}
