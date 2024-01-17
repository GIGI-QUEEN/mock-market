import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String? token = dotenv.env['FINNHUB_TOKEN'];
final String apiKey = dotenv.env['IEX_API_KEY'] ?? '';

class NetworkService {
  Future<List<Map<String, dynamic>>?> fetchHistoricalStockData(
      String stock, String range) async {
    log('in fetchHistoricalStockData, range: $range');

    try {
      var url = Uri.parse(
          'https://api.iex.cloud/v1/data/core/historical_prices/$stock?range=$range&token=$apiKey');

      var response = await http.get(url);

      if (response.statusCode == 200) {
        //log('Response: ${response.body}');
        dynamic jsonData = json.decode(response.body);
        List<Map<String, dynamic>> dataList =
            jsonData.cast<Map<String, dynamic>>();
        return dataList;
      } else {
        log('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }

  Future<Map<String, num>> fetchSymbolV2(String symbol) async {
    final Map<String, num> priceMap = {
      'currentPrice': 0,
      'percentChange': 0,
    };
    var url = Uri.parse(
        'https://finnhub.io/api/v1/quote?symbol=$symbol&token=$token');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      priceMap.update('currentPrice', (value) => jsonData['c'] as num);
      priceMap.update('percentChange', (value) => jsonData['dp'] as num);
      return priceMap;
      //return jsonData['c'] as num;
    } else {
      return priceMap;
    }
  }

  Future<num> fetchSymbol(String symbol) async {
    var url = Uri.parse(
        'https://finnhub.io/api/v1/quote?symbol=$symbol&token=$token');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['c'] as num;
    } else {
      return 0;
    }
  }
}
