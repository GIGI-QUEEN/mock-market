import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:stock_market/models/stock.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const token = 'cme3jqpr01qlj4jqsuc0cme3jqpr01qlj4jqsucg';

class NetworkService {
  Future<void> fetchStockData(String stockName) async {
    log('in fetchData');
    try {
      var url = Uri.parse('http://172.1.1.106:5001/exchange_rate/$stockName');

      var response = await http.get(url);

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  WebSocketChannel getRealTimeStockData() {
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
  }
}
