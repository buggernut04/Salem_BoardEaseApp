import 'package:flutter/material.dart';

class TenantStatus extends StatefulWidget {
  const TenantStatus({Key? key}) : super(key: key);

  @override
  State<TenantStatus> createState() => _TenantStatusState();
}

class _TenantStatusState extends State<TenantStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tenant Status'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            TextButton(
              onPressed: () {},
              child: Text(
                  'Update Tenant',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[600],
                  )
              ),
            ),
            Text('Name: '),
            Text('Phone Number: '),
            Text('Payment Status: '),
          ],
        ),
      )
    );
  }
}
