import 'package:boardease_application/graph/electricbill/ebgraph_data.dart';
import 'package:boardease_application/graph/waterbill/wbgraph_data.dart';
import 'package:flutter/material.dart';


class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
                            'Water Bill',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey[600],
                            )
                        ),
                      ),
                      Tab(
                        child: Text(
                            'Electric Bill',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey[600],
                            )
                        ),
                      ),
                      Tab(
                        child: Text(
                            'Profit',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey[600],
                            )
                        ),
                      )
                    ]
                ),

                Expanded(
                  child: TabBarView(
                      children: [
                        WaterBillData(),
                        ElectricBillData(),
                        Container(),
                      ]
                  ),
                ),

              ],
            ),
          )
      ),
    );
  }
}
