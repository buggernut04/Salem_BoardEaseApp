import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';


class RecordBar extends StatefulWidget {
  const RecordBar({Key? key, required this.tenantsNum, required this.color, required this.allTenantsNum, required this.statusDisplay, required this.filteredList}) : super(key: key);

  final Widget filteredList;
  final String statusDisplay;
  final int tenantsNum;
  final int allTenantsNum;
  final Color? color;

  @override
  State<RecordBar> createState() => _RecordBarState();
}

class _RecordBarState extends State<RecordBar> {

  Column enlargeText(String val1, String val2){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          val1,
          style: const TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w900,
              fontSize: 40.0,
          ),
          textAlign: TextAlign.center,
        ),

        Text(
          val2,
          style: const TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            fontSize: 16.0
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 13.0),
          child: CircularPercentIndicator(
            circularStrokeCap: CircularStrokeCap.round,
            radius: 220.0,
            lineWidth: 23.0,
            backgroundColor: Colors.grey,
            percent: widget.tenantsNum == 0 ? 0.0 : widget.tenantsNum / widget.allTenantsNum,
            center: enlargeText('${widget.tenantsNum} / ${widget.allTenantsNum}', widget.statusDisplay),
            animation: true,
            animationDuration: 1500,
            progressColor: widget.color,
          ),
        ),

        Expanded(
            flex: 1,
            child: widget.filteredList
        ),
      ]
    );
  }
}