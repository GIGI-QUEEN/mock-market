import 'package:stock_market/services/network.dart';
import 'package:stock_market/views/historical.dart';

final networkService = NetworkService();

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

