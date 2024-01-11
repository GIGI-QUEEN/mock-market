import 'package:stock_market/components/buy_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  bool _showCandlestickChart = false;
  String _dateFormatPattern = 'dd/M';

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
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            buildToggleButton(),
            buildChart(),
            buildButtons(),
            BuyButton(stockSymbol: widget.stockSymbol),
          ],
        ),
      ),
    );
  }

  Widget buildChart() {
    return _chartData.isNotEmpty
        ? _showCandlestickChart
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
                primaryXAxis: DateTimeAxis(
                  interval: 1,
                  dateFormat: DateFormat(_dateFormatPattern),
                  minimum: _minimumDate.add(const Duration(days: 1)),
                  maximum: _maximumDate.subtract(const Duration(days: 1)),
                  majorGridLines: const MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  minimum: _minimumValue - 0.5,
                  maximum: _maximumValue + 0.5,
                  interval: 1.5,
                  numberFormat: NumberFormat.simpleCurrency(decimalDigits: 2),
                ),
              )
            : SfCartesianChart(
                title: ChartTitle(text: widget.stockSymbol),
                trackballBehavior: _trackballBehavior,
                series: <LineSeries>[
                  LineSeries<ChartSampleData, DateTime>(
                    animationDuration: 0,
                    dataSource: _chartData,
                    xValueMapper: (ChartSampleData sales, _) => sales.x,
                    yValueMapper: (ChartSampleData sales, _) => sales.close,
                  )
                ],
                primaryXAxis: DateTimeAxis(
                  interval: 1,
                  dateFormat: DateFormat(_dateFormatPattern),
                  minimum: _minimumDate,
                  maximum: _maximumDate,
                  majorGridLines: const MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  minimum: _minimumValue - 0.5,
                  maximum: _maximumValue + 0.5,
                  interval: 1.5,
                  numberFormat: NumberFormat.simpleCurrency(decimalDigits: 2),
                ),
              )
        : const Center(child: CircularProgressIndicator());
  }

  Widget buildToggleButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _showCandlestickChart = !_showCandlestickChart;
        });
      },
      child: Text(_showCandlestickChart ? 'Line' : 'Candlestick'),
    );
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildButton("1W", "7d"),
        buildButton("1M", "1m"),
        buildButton("3M", "3m"),
        buildButton("6M", "6m"),
        buildButton("1Y", "1y"),
      ],
    );
  }

  Widget buildButton(String text, String duration) {
    return ElevatedButton(
      onPressed: () => fetchDataForDuration(duration),
      child: Text(text),
    );
  }

  Future<void> fetchDataForDuration(String duration) async {
    _chartData = await getChartData(widget.stockSymbol, duration);
    if (mounted) {
      setState(() {
        _minimumValue = calculateMinimumValue(_chartData);
        _maximumValue = calculateMaximumValue(_chartData);
        _minimumDate = calculateMinimumDate(_chartData);
        _maximumDate = calculateMaximumDate(_chartData);

        if (duration == "7d" || duration == "1m") {
          _dateFormatPattern = 'dd/M';
        } else {
          _dateFormatPattern = 'MMM/yy';
        }
      });
    }
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
    return parseChartDataFromJson(jsonDataList);
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
