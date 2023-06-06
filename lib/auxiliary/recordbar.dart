import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../database/databasehelper.dart';


class RecordBar extends StatefulWidget {
  const RecordBar({Key? key}) : super(key: key);

  @override
  State<RecordBar> createState() => _RecordBarState();
}

class _RecordBarState extends State<RecordBar> {

  int _allTenants = 0;
  int _allTenantsNotPayed = 0;

  @override
  void initState() {
    super.initState();
    _fetchAllTenantCount();
    _fetchAllNotPayedTenantCount();
  }

  @override
  void dispose(){
    super.dispose();
  }

  void _fetchAllTenantCount() {
    DatabaseHelper.databaseHelper.getAllTenantNum().then((count) {
      setState(() {
        _allTenants = count!.toInt();
      });
    });
  }

  void _fetchAllNotPayedTenantCount() {
    DatabaseHelper.databaseHelper.getNotPayedTenantNum().then((count) {
      setState(() {
        _allTenantsNotPayed = count!.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return CircularPercentIndicator(
      radius: 120.0,
      lineWidth: 20.0,
      percent: _allTenants == 0 ? 0.0 : _allTenantsNotPayed / _allTenants,
      center: _allTenantsNotPayed == 0 ? Text('0%') : Text('${(_allTenantsNotPayed / _allTenants * 100).toInt()}%') ,
      animation: true,
      animationDuration: 1500,
      progressColor: Colors.indigo,
    );
  }
}