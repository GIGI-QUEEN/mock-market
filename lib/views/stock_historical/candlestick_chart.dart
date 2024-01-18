import 'package:flutter/material.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/views/stock_historical/historical.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CandleStickChart extends StatelessWidget {
  const CandleStickChart({
    super.key,
    required this.stock,
    required this.trackballBehavior,
    required this.chartData,
  });
  final Stock stock;
  final TrackballBehavior trackballBehavior;
  final List<ChartSampleData> chartData;
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      /* title: ChartTitle(
        text: "${stock.symbol} - \$${stock.price}",
      ), */
      trackballBehavior: trackballBehavior,
      series: <CandleSeries>[
        CandleSeries<ChartSampleData, DateTime>(
          animationDuration: 0,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          lowValueMapper: (ChartSampleData sales, _) => sales.low,
          highValueMapper: (ChartSampleData sales, _) => sales.high,
          openValueMapper: (ChartSampleData sales, _) => sales.open,
          closeValueMapper: (ChartSampleData sales, _) => sales.close,
        )
      ],
      primaryXAxis: const DateTimeAxis(
        isVisible: false,
      ),
      primaryYAxis: const NumericAxis(
        isVisible: false,
      ),
    );
  }
}
