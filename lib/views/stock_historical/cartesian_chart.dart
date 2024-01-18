import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/providers/single_stock_data_provider.dart';
import 'package:stock_market/views/stock_historical/historical.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CartesianChart extends StatelessWidget {
  const CartesianChart({
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
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        isVisible: false,
      ),
    );
  }
}
