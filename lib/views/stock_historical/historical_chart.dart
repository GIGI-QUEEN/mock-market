import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/views/stock_historical/candlestick_chart.dart';
import 'package:stock_market/views/stock_historical/cartesian_chart.dart';
import 'package:stock_market/views/stock_historical/historical.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HistoricalChart extends StatelessWidget {
  const HistoricalChart({
    super.key,
    required this.showCandlestickChart,
    required this.stock,
    required this.trackballBehavior,
    required this.chartData,
  });
  final bool showCandlestickChart;
  final Stock stock;
  final TrackballBehavior trackballBehavior;
  final List<ChartSampleData> chartData;

  @override
  Widget build(BuildContext context) {
    return showCandlestickChart
        ? CandleStickChart(
            stock: stock,
            trackballBehavior: trackballBehavior,
            chartData: chartData)
        : CartesianChart(
            stock: stock,
            trackballBehavior: trackballBehavior,
            chartData: chartData);
  }
}
