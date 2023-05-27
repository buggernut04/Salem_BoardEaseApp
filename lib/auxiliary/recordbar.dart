import 'package:flutter/material.dart';

import '../classes/paymentstatus.dart';
import '../classes/tenant.dart';

class RecordBar extends StatefulWidget {
  const RecordBar({Key? key}) : super(key: key);

  @override
  State<RecordBar> createState() => _RecordBarState();
}

class _RecordBarState extends State<RecordBar> {

  List<Tenant> tenant = [
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09978601212',  status: PaymentStatus.notPayed, startDate: DateTime.now()),
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09978601212',  status: PaymentStatus.notPayed, startDate: DateTime.now()),
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09978601212',  status: PaymentStatus.notPayed, startDate: DateTime.now()),
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09978621212',  status: PaymentStatus.notFullyPayed, startDate: DateTime.now()),
    Tenant(name: 'Michael Cye R. Salem', contactInfo: '09438601212',  status: PaymentStatus.fullyPayed, startDate: DateTime.now())
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          TweenAnimationBuilder(
            tween: Tween(begin: 0.0, end: tenant.length / 30),
            duration: Duration(seconds: 3),
            builder: (context, value, _) => SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                  value: value,
                  valueColor: AlwaysStoppedAnimation<Color> (Colors.blueAccent),
                  strokeWidth: 8,
                  backgroundColor: Colors.black38,
                ),
            ),
          ),
            SizedBox(height: 16.0),
            Text('Progress: ${(tenant.length - 5 / tenant.length * 100).toStringAsFixed(1)}%'),
          ],
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

