import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/views/stock_historical/candlestick_chart.dart';
import 'package:stock_market/views/stock_historical/line_chart.dart';
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
        : LineChart(
            stock: stock,
            trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              tooltipSettings: const InteractiveTooltip(
                  format: 'point.y',
                  color: Color.fromARGB(85, 155, 152, 152),
                  textStyle: TextStyle(
                    color: Colors.black,
                  )),
              lineType: TrackballLineType.none,
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
            ),
            chartData: chartData,
            crosshairBehavior: CrosshairBehavior(
              activationMode: ActivationMode.singleTap,
              enable: true,
              lineType: CrosshairLineType.both,
            ),
          );
  }
}
