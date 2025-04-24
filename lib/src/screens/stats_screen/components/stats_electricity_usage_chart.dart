import 'package:domus/config/size_config.dart';
import 'package:domus/model/consumption.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'stats_chart.dart';

class StatsElectricityUsageChart extends StatelessWidget {
  const StatsElectricityUsageChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Consumption> data = [
      Consumption('Jan', 35),
      Consumption('Feb', 28),
      Consumption('Mar', 34),
      Consumption('Apr', 32),
      Consumption('May', 40),
    ];

    return StatsChart(
      title: 'Electricity Usage',
      subtitle: 'Usage per month',
      content: data,
    );
  }
}
