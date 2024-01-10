import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

import '../services/network.dart';

class StockHistoricalView extends StatefulWidget {
  final String stockSymbol;
  const StockHistoricalView({Key? key, required this.stockSymbol})
      : super(key: key);

  @override
  State<StockHistoricalView> createState() => _StockHistoricalViewState();
}

class _StockHistoricalViewState extends State<StockHistoricalView> {
  final networkService = NetworkService();
  late List<ChartSampleData> _chartData = [];
  late TrackballBehavior _trackballBehavior;
  late double _minimumValue;
  late double _maximumValue;
  late DateTime _minimumDate;
  late DateTime _maximumDate;

  @override
  void initState() {
    fetchChartData();
    super.initState();
  }

  void fetchChartData() async {
    _chartData = await getChartData(widget.stockSymbol, "7d");
    if (mounted) {
      setState(() {
        _trackballBehavior = TrackballBehavior(
            enable: true, activationMode: ActivationMode.singleTap);
        _minimumValue = calculateMinimumValue(_chartData);
        _maximumValue = calculateMaximumValue(_chartData);
        _minimumDate = calculateMinimumDate(_chartData);
        _maximumDate = calculateMaximumDate(_chartData);
      });
    }
  }

  double calculateMinimumValue(List<ChartSampleData> data) {
    double min = double.infinity;
    for (final chartData in data) {
      if (chartData.low != null && chartData.low! < min) {
        min = chartData.low! as double;
      }
    }
    return min;
  }

  double calculateMaximumValue(List<ChartSampleData> data) {
    double max = double.negativeInfinity;
    for (final chartData in data) {
      if (chartData.high != null && chartData.high! > max) {
        max = chartData.high! as double;
      }
    }
    return max;
  }

  DateTime calculateMinimumDate(List<ChartSampleData> data) {
    return data.isNotEmpty ? data.first.x! : DateTime.now();
  }

  DateTime calculateMaximumDate(List<ChartSampleData> data) {
    return data.isNotEmpty ? data.last.x! : DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    const Duration bufferDuration = Duration(days: 1);

    return SafeArea(
        child: Scaffold(
      body: _chartData.isNotEmpty
          ? SfCartesianChart(
              title: ChartTitle(text: widget.stockSymbol),
              trackballBehavior: _trackballBehavior,
              series: <CandleSeries>[
                CandleSeries<ChartSampleData, DateTime>(
                  dataSource: _chartData,
                  xValueMapper: (ChartSampleData sales, _) => sales.x,
                  lowValueMapper: (ChartSampleData sales, _) => sales.low,
                  highValueMapper: (ChartSampleData sales, _) => sales.high,
                  openValueMapper: (ChartSampleData sales, _) => sales.open,
                  closeValueMapper: (ChartSampleData sales, _) => sales.close,
                )
              ],
              //primaryXAxis: const DateTimeAxis(),
              primaryXAxis: DateTimeAxis(
                interval: 1,
                dateFormat:
                    DateFormat('dd/M'),
                minimum: _minimumDate.add(bufferDuration),
                maximum: _maximumDate.subtract(bufferDuration),
                majorGridLines: const MajorGridLines(width: 0),
              ),

              primaryYAxis: NumericAxis(
                minimum: _minimumValue - 0.5,
                maximum: _maximumValue + 0.5,
                interval: 0.54,
                numberFormat: NumberFormat.simpleCurrency(decimalDigits: 2),
                // majorGridLines: const MajorGridLines(width: 0),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    ));
  }

  List<ChartSampleData> parseChartDataFromJson(List<dynamic> jsonList) {
    return jsonList.map((jsonData) {
      return ChartSampleData(
        x: DateTime.parse(jsonData['priceDate']),
        open: jsonData['open'] ?? 0.0,
        high: jsonData['high'] ?? 0.0,
        low: jsonData['low'] ?? 0.0,
        close: jsonData['close'] ?? 0.0,
      );
    }).toList();
  }

  Future<List<ChartSampleData>> getChartData(
      String stockName, String period) async {
    List<Map<String, dynamic>> jsonDataList =
        await networkService.fetchHistoricalStockData(stockName, period)
            as List<Map<String, dynamic>>;
    final result = parseChartDataFromJson(jsonDataList);
    for (final r in result) {
      log('r: ');
      log(r.x.toString());
    }
    return result;
  }
}

class ChartSampleData {
  ChartSampleData({this.x, this.open, this.close, this.low, this.high});
  final DateTime? x;
  final num? open;
  final num? close;
  final num? low;
  final num? high;
}
