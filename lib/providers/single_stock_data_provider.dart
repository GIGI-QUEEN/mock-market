import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/services/charts.dart';
import 'package:stock_market/views/stock_historical/historical.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SingleStockDataProvider extends ChangeNotifier {
  TrackballBehavior _trackballBehavior = TrackballBehavior(enable: false);
  late List<ChartSampleData> _chartData = [];
  final ChartsService _chartsService = ChartsService();
  final Stock stock;
  bool _showCandlestickChart = false;
  bool get showCanglestickChart => _showCandlestickChart;
  TrackballBehavior? get trackballBehavior => _trackballBehavior;
  List<ChartSampleData> get chartData => _chartData;

  String _currentPeriod = '7d';
  String get currentPeriod => _currentPeriod;

  List<bool> _selectedChart = [true, false];
  List<bool> get selectedChart => _selectedChart;
  void fetchChartData() async {
    _chartData = await _chartsService.getChartData(stock.symbol, "7d");

    _trackballBehavior = TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap);

    notifyListeners();
  }

  Future<void> fetchDataForDuration(String duration) async {
    _chartData = await _chartsService.getChartData(stock.symbol, duration);
    _currentPeriod = duration;
    notifyListeners();
  }

  void switchChart(int index) {
    _showCandlestickChart = !_showCandlestickChart;
    for (int i = 0; i < _selectedChart.length; i++) {
      _selectedChart[i] = i == index;
    }
    notifyListeners();
  }

  SingleStockDataProvider({required this.stock}) {
    fetchChartData();
  }
}
