import 'package:domus/config/size_config.dart';
import 'package:domus/model/consumption.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:domus/theme/text_theme_extension.dart';
import 'stats_chart.dart';

class StatsDeviceConsumptionChart extends StatelessWidget {
  const StatsDeviceConsumptionChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Consumption> data = [
      Consumption('First', 20),
      Consumption('Mon', 22),
      Consumption('Tue', 30),
      Consumption('Wed', 36),
      Consumption('Thur', 19),
      Consumption('Fri', 25),
      Consumption('Sat', 20),
      Consumption('Sun', 33),
      Consumption('Last', 20),
    ];

    return Container(
      height: getProportionateScreenHeight(250),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFFFFFFF),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(10),
          vertical: getProportionateScreenHeight(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Consumption by device',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Check level 240',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < data.length) {
                            return Text(data[value.toInt()].month);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.value.toDouble());
                      }).toList(),
                      isCurved: true,
                      color: const Color(0xFF464646),
                      barWidth: 2,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF464646).withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
