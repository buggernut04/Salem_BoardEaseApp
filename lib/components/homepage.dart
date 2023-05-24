import 'package:boardease_application/auxiliary/recordbar.dart';
import 'package:boardease_application/auxiliary/tenantcard.dart';
import 'package:boardease_application/classes/paymentstatus.dart';
import 'package:boardease_application/classes/tenant.dart';
import 'package:boardease_application/components/tenant_list.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget    {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Tenant> tenants = [
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09978601212', email: 'grrrr', status: PaymentStatus.notPayed, startDate: DateTime.now()),
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09978601212', email: 'grrrr', status: PaymentStatus.notPayed, startDate: DateTime.now()),
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09978601212', email: 'grrrr', status: PaymentStatus.notPayed, startDate: DateTime.now()),
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09978621212', email: 'grrrr', status: PaymentStatus.notFullyPayed, startDate: DateTime.now()),
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09438601212', email: 'grrrr', status: PaymentStatus.fullyPayed, startDate: DateTime.now())
  ];


  @override
  Widget build(BuildContext context) {
    print(tenants.length);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('BoardEase'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        elevation: 0.0,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0,10.0),
                child: Container(
                    child: RecordBar(tenant: tenants)
                )
            ),
            Expanded(
              flex: 1,
              child: TenantList(tenant: tenants),
            )
          ],
      )
    );
  }

}

