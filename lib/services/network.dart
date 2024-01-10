import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:stock_market/models/stock.dart';

final String? token = dotenv.env['FINNHUB_TOKEN'];
final String apiKey = dotenv.env['IEX_API_KEY'] ?? '';

class NetworkService {
  Future<List<Map<String, dynamic>>?> fetchHistoricalStockData(
      String stock, String range /* List<String> stocks */) async {
    log('in fetchHistoricalStockData, range: $range');

    try {
      var url = Uri.parse(
          'https://api.iex.cloud/v1/data/core/historical_prices/$stock?range=$range&token=$apiKey');

      var response = await http.get(url);

      if (response.statusCode == 200) {
        log('Response: ${response.body}');
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
//Currently unused
/*   WebSocketChannel getRealTimeStockData() {
    final channel = WebSocketChannel.connect(
      Uri.parse('wss://ws.finnhub.io?token=$token'),
    );
    //final stocks = ['AAPL', 'AMZN', 'TSLA']; //will be extended
    // final aapl = {"\"type\"": "\"subscribe\"", "\"symbol\"": "\"AAPL\""};
    // final Map<String, Stock> stocksMap = {};
    final aapl = {'type': 'subscribe', 'symbol': 'AAPL'};
    final amzn = {'type': 'subscribe', 'symbol': 'AMZN'};
    final tsla = {'type': 'subscribe', 'symbol': 'TSLA'};
    channel.sink.add(jsonEncode(aapl));
    channel.sink.add(jsonEncode(amzn));
    channel.sink.add(jsonEncode(tsla));

    return channel;
    /* channel.stream.listen((event) {
      final data = jsonDecode(event);

      final stock = Stock.fromJson2(data);
      stocksMap.update(stock.symbol, (value) => stock, ifAbsent: () => stock);
    }); */
  } */
}
