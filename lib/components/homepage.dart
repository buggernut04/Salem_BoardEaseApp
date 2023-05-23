import 'package:boardease_application/auxiliary/recordbar.dart';
import 'package:boardease_application/auxiliary/tenantcard.dart';
import 'package:boardease_application/classes/paymentstatus.dart';
import 'package:boardease_application/classes/tenant.dart';
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
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09978601212', email: 'grrrr', status: PaymentStatus.notPayed, startDate: DateTime.now()),
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09978601212', email: 'grrrr', status: PaymentStatus.notPayed, startDate: DateTime.now()),
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09978601212', email: 'grrrr', status: PaymentStatus.notPayed, startDate: DateTime.now()),
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09978601212', email: 'grrrr', status: PaymentStatus.notPayed, startDate: DateTime.now()),
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09978601212', email: 'grrrr', status: PaymentStatus.notPayed, startDate: DateTime.now()),
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09978601212', email: 'grrrr', status: PaymentStatus.notPayed, startDate: DateTime.now())
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('BoardEase'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        elevation: 0.0,
      ),
      body: content(),
    );
}

 Widget content(){
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Center(
          //padding: EdgeInsets.fromLTRB(40.0, 50.0, 40.0, 30.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
                Expanded(
                  flex: 1,
                  child:Container(
                      child: RecordBar(tenant: tenants)
                  ),
                ),
                SizedBox(height: 10.0),
                Column(
                  children: tenants.map((tenant) => TenantCard(tenant: tenant)).toList(),
                ),
              ],
            )
          ),
        ),
        ]
    );
  }
}