import 'package:flutter/material.dart';

import '../database/databasehelper.dart';


class RecordBar extends StatefulWidget {
  const RecordBar({Key? key}) : super(key: key);

  @override
  State<RecordBar> createState() => _RecordBarState();
}

class _RecordBarState extends State<RecordBar> {

  double _allTenants = 0.0;
  double _allTenantsNotPayed = 0.0;


  @override
  void initState() {
    super.initState();
    _fetchTenantCount();
  }

  void _fetchTenantCount() {
    DatabaseHelper.databaseHelper.getAllTenantNum().then((count) {
      setState(() {
        _allTenants = count!.toDouble();
      });
    });

    DatabaseHelper.databaseHelper.getNotPayedTenantNum().then((count) {
      setState(() {
        _allTenantsNotPayed = count!.toDouble();
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
            tween: Tween(begin: 0.0, end: _allTenantsNotPayed / _allTenants),
            duration: Duration(seconds: 3),
            builder: (context, value, _) => SizedBox(
              width: 100,
              height: 50,
              child: CircularProgressIndicator(
                  value:  value,
                  valueColor: AlwaysStoppedAnimation<Color> (Colors.blueAccent),
                  strokeWidth: 15,
                  backgroundColor: Colors.black38,
                ),
            ),
          ),
            SizedBox(height: 16.0),
            Text('${(_allTenantsNotPayed)} / ${(_allTenants)}'),
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

