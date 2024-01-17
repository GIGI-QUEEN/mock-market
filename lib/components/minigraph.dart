import 'package:flutter/material.dart';
import 'package:stock_market/views/historical.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MiniGraph extends StatelessWidget {
  final List<ChartSampleData> chartData;
  final int growth;

  const MiniGraph({
    super.key,
    required this.chartData,
    required this.growth,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: 80,
      width: 200,
      child: SfCartesianChart(
        series: <LineSeries>[
          LineSeries<ChartSampleData, DateTime>(
            animationDuration: 0,
            dataSource: chartData,
            xValueMapper: (ChartSampleData sales, _) => sales.x,
            yValueMapper: (ChartSampleData sales, _) => sales.close,
            color: growth > 0 ? const Color(0xFF22CC9E) : Colors.red,
          )
        ],
        primaryXAxis: const DateTimeAxis(
          isVisible: false,
          majorGridLines: MajorGridLines(width: 0),
        ),
        primaryYAxis: const NumericAxis(
          isVisible: false,
        ),
      ),
    );
  }
}
