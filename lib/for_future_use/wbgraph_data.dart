/*
import 'package:boardease_application/graph/waterbill/wbgraph.dart';
import 'package:flutter/material.dart';

class WaterBillData extends StatefulWidget {
  const WaterBillData({Key? key}) : super(key: key);

  @override
  State<WaterBillData> createState() => _WaterBillDataState();
}

class _WaterBillDataState extends State<WaterBillData> {

  List<double> monthlySummarySample = [
    1000.0,
    2340.0,
    1456.0,
    1758.0,
    2879.0,
    1762.0,
    2367.0,
    1289.0,
    1002.0,
    2343.0,
    1789.0,
    1349.0,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: AlignmentDirectional.topStart,
          child: Padding(
            padding: const EdgeInsets.only(left: 9.0),
            child: Row(
              children: [
                const Text(
                  'Monthly Water Bill',
                  style: TextStyle(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'View all  ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: const <Widget>[
              Icon(
                Icons.sell_outlined,
                size: 20,
              ),
              */
/*Text(
                        'Total: ',
                        style: TextStyle(
                          fontSize: 17,
                          //color: Colors.green.shade600,
                        ),
                      ),*//*

              Text(
                ' ₱1000.0}',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  //color: Colors.green.shade600,
                ),
              ),
            ],
          ),
        ),

        Center(
          child: SizedBox(
            height: 230,
            child: WaterBillGraph(
              monthlyPayments: monthlySummarySample,
            ),
          ),
        )
      ],
    );
  }
}
*/
