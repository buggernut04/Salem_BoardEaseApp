import 'package:boardease_application/auxiliary/tenant_status.dart';

import 'package:flutter/material.dart';

import '../auxiliary/recordbar.dart';

class MyHomePage extends StatefulWidget    {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: const Text('BoardEase'),
            centerTitle: true,
            backgroundColor: Colors.blue[300],
            elevation: 0.0,
          ),
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0,10.0),
                  child: RecordBar()
              ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return TenantStatus();
                        }));
                      },
                      child: Text('View these Tenants'),
                  )
            ]
        ),
          ),
     );
  }
}

