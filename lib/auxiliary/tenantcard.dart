import 'package:flutter/material.dart';

import '../classes/tenant.dart';

class TenantCard extends StatelessWidget {
  const TenantCard({Key? key, required this.tenant}) : super(key: key);

  final Tenant tenant;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0,5.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              tenant.name,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              )
            ),
            SizedBox(height: 5.0),
            Text(
                "Not Payed",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[600],
                )
            ),
          ],
        )
      )
    );
  }
}
