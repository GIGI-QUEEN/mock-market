import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/services/charts.dart';
import 'package:stock_market/services/network.dart';
import 'package:stock_market/views/stock_historical/historical.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SingleStockDataProvider extends ChangeNotifier {
  TrackballBehavior _trackballBehavior = TrackballBehavior(enable: false);
  late List<ChartSampleData> _chartData = [];
  final ChartsService _chartsService = ChartsService();
  Stock stock;
  bool _showCandlestickChart = false;
  bool get showCandlestickChart => _showCandlestickChart;
  TrackballBehavior? get trackballBehavior => _trackballBehavior;
  List<ChartSampleData> get chartData => _chartData;
  late StreamSubscription _streamSubscription;

  String _currentPeriod = '7d';
  String get currentPeriod => _currentPeriod;

  final List<bool> _selectedChart = [true, false];
  List<bool> get selectedChart => _selectedChart;
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://ws.finnhub.io?token=$token2'),
  );
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

  getRealTimeStockData() {
    final message = {'type': 'subscribe', 'symbol': stock.symbol};
    channel.sink.add(jsonEncode(message));

    _streamSubscription = channel.stream.listen((event) {
      final data = jsonDecode(event);
      if (data['type'] != 'ping') {
        stock = Stock.fromJson2(data);

        notifyListeners();
      }
    });
  }

  SingleStockDataProvider({required this.stock}) {
    fetchChartData();
    getRealTimeStockData();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
    channel.sink.close();
  }
}
