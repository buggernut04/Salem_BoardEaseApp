import 'package:boardease_application/classes/paymentstatus.dart';
import 'package:flutter/material.dart';

import '../classes/tenant.dart';

class TenantCard extends StatelessWidget {
  const TenantCard({Key? key, required this.tenant}) : super(key: key);

  final Tenant tenant;

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(1.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0,1.0),
        child: ListTile(
          onTap: () {},
          title: Text( tenant.name,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[600],
                )
              ),
          )
        )
      );
}
