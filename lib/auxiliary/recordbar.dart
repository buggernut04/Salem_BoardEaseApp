
import 'package:flutter/material.dart';

import '../classes/tenant.dart';

class RecordBar extends StatelessWidget {
  const RecordBar({Key? key, required this.tenant}) : super(key: key);

  final List<Tenant> tenant;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              CircularProgressIndicator(
                  strokeWidth: 10,
                  backgroundColor: Colors.yellow,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  value: tenant.length - 5 / tenant.length,
                ),
                SizedBox(height: 16.0),
                Text('Progress: ${(tenant.length - 5 / tenant.length * 100).toStringAsFixed(1)}%'),
              ],
            ),
          ),
        ),
    );
  }
}

/*class RecordBar extends StatefulWidget {
  const RecordBar({Key? key, required this.tenant}) : super(key: key);

  final List<Tenant> tenant;

  @override
  State<RecordBar> createState() => _RecordBarState();
}

class _RecordBarState extends State<RecordBar> {
  late bool _loading;
  late double _progressValue = 0.0;


  @override
  void initState() {
    super.initState();
    _loading = false;
    updateProgress();
  }

  void updateProgress() {
    setState(() {
      _progressValue = 0.5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(14.0),
        child: _loading
        ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              strokeWidth: 10,
              backgroundColor: Colors.yellow,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              value: _progressValue,
            ),
            Text('${(_progressValue * 100).round()}%'),
          ],
        )
            : Text("Press button for downloading", style: TextStyle(fontSize: 25)),
    );
  }
}*/

