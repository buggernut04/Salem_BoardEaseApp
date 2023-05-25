import 'package:boardease_application/auxiliary/bottom_navbar.dart';
import 'package:boardease_application/components/payment_analysis.dart';
import 'package:boardease_application/components/profile.dart';
import 'package:boardease_application/components/tenant_list.dart';
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
            backgroundColor: Colors.blueGrey,
            elevation: 0.0,
          ),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0,10.0),
                child: Container(
                  child: RecordBar()
                )
          ),
        ]
      ),
    );
  }
}

