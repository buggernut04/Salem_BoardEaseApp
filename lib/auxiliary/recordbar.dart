import 'package:flutter/material.dart';

import '../database/databasehelper.dart';


class RecordBar extends StatefulWidget {
  const RecordBar({Key? key}) : super(key: key);

  @override
  State<RecordBar> createState() => _RecordBarState();
}

class _RecordBarState extends State<RecordBar> {

  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchTenantCount();
  }

  void _fetchTenantCount() {
    DatabaseHelper.databaseHelper.getTenantCount().then((count) {
      setState(() {
        _progress = count!.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          TweenAnimationBuilder(
            tween: Tween(begin: 0.0, end: _progress),
            duration: Duration(seconds: 3),
            builder: (context, value, _) => SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                  value: _progress,
                  valueColor: AlwaysStoppedAnimation<Color> (Colors.blueAccent),
                  strokeWidth: 8,
                  backgroundColor: Colors.black38,
                ),
            ),
          ),
            SizedBox(height: 16.0),
            Text('Progress: ${(_progress)} / ${(_progress)}'),
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

