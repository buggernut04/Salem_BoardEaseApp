import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../bar_data.dart';


class ElectricBillGraph extends StatelessWidget {
  final List monthlyPayments;

  const ElectricBillGraph({
    super.key,
    required this.monthlyPayments,
  });


  final double maxY = 3000;
  /*final double janAmount;
  final double febAmount;
  final double marAmount;
  final double aprAmount;
  final double mayAmount;
  final double junAmount;
  final double julAmount;
  final double augAmount;
  final double sepAmount;
  final double octAmount;
  final double novAmount;
  final double decAmount;
*/
  /*const WaterBillGraph(
      {super.key,
        janA janAmount,
        required this.febAmount,
        required this.marAmount,
        required this.aprAmount,
        required this.mayAmount,
        required this.junAmount,
        required this.julAmount,
        required this.augAmount,
        required this.sepAmount,
        required this.octAmount,
        required this.novAmount,
        required this.decAmount,});*/

  @override
  Widget build(BuildContext context) {
    BarData monthlyPayment = BarData(
        janAmount: monthlyPayments[0],
        febAmount: monthlyPayments[1],
        marAmount: monthlyPayments[2],
        aprAmount: monthlyPayments[3],
        mayAmount: monthlyPayments[4],
        junAmount: monthlyPayments[5],
        julAmount: monthlyPayments[6],
        augAmount: monthlyPayments[7],
        sepAmount: monthlyPayments[8],
        octAmount: monthlyPayments[9],
        novAmount: monthlyPayments[10],
        decAmount: monthlyPayments[11]
    );
    monthlyPayment.initializeBarData();
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: BarChart(
          BarChartData(
            barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                  fitInsideVertically: true,
                )
            ),
            maxY: maxY,
            minY: 0,
            gridData: FlGridData(
              show: false,
            ),
            borderData: FlBorderData(
              show: false,
            ),
            titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: getBottomTitles,
                  )),
            ),
            barGroups: monthlyPayment.barData
                .map((data) => BarChartGroupData(x: data.x, barRods: [
              BarChartRodData(
                  toY: data.y,
                  color: Colors.blue.shade500.withOpacity(0.9),
                  width: 20,
                  borderRadius: BorderRadius.circular(7),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    //toY: ,
                    color: Colors.blue.shade100,
                  )),
            ]))
                .toList(),
          )),
    );
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontSize: 12.5,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Jan', style: style);
        break;
      case 1:
        text = const Text('Feb', style: style);
        break;
      case 2:
        text = const Text('Mar', style: style);
        break;
      case 3:
        text = const Text('Apr', style: style);
        break;
      case 4:
        text = const Text('May', style: style);
        break;
      case 5:
        text = const Text('Jun', style: style);
        break;
      case 6:
        text = const Text('Jul', style: style);
        break;
      case 7:
        text = const Text('Aug', style: style);
        break;
      case 8:
        text = const Text('Sep', style: style);
        break;
      case 9:
        text = const Text('Oct', style: style);
        break;
      case 10:
        text = const Text('Nov', style: style);
        break;
      case 11:
        text = const Text('Dec', style: style);
        break;
      default:
        text = const Text('', style: style);
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }
}