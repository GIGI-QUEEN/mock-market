import 'package:flutter/material.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/views/stock_historical/historical.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatelessWidget {
  const LineChart({
    super.key,
    required this.stock,
    required this.trackballBehavior,
    required this.chartData,
    required this.crosshairBehavior,
  });

  final Stock stock;
  final TrackballBehavior trackballBehavior;
  final List<ChartSampleData> chartData;
  final CrosshairBehavior crosshairBehavior;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      /*  title: ChartTitle(
        text: "${stock.symbol} - \$${stock.price}",
      ), */
      margin: const EdgeInsets.all(0),
      trackballBehavior: trackballBehavior,
      series: <LineSeries>[
        LineSeries<ChartSampleData, DateTime>(
          animationDuration: 0,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.close,
          color: const Color(0xFF22CC9E),
        )
      ],
      primaryXAxis: const DateTimeAxis(
        isVisible: false,
      ),
      primaryYAxis: const NumericAxis(
        isVisible: false,
      ),
      crosshairBehavior: crosshairBehavior,
    );
  }
}
