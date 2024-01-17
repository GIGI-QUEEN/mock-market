import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:stock_market/constants/stock_list.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/services/network.dart';

class StockDataProviderV2 extends ChangeNotifier {
  final Map<String, Stock> _stocksMap = {};
  Map<String, Stock> get stocksMap => _stocksMap;
  final NetworkService _networkService = NetworkService();
  late StreamSubscription _streamSubscription;
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://ws.finnhub.io?token=$token'),
  );
  bool _isDisposed = false;

  void _initialFetch() async {
    if (_isDisposed) return;
    for (var stockName in stockList) {
      final initialPrice = await _networkService.fetchSymbol(stockName);
      if (_isDisposed) return;
      final preFetchedStock =
          Stock(price: initialPrice, symbol: stockName, time: DateTime.now());
      _stocksMap.update(stockName, (value) => preFetchedStock,
          ifAbsent: () => preFetchedStock);
    }
    if (_isDisposed) return;
    notifyListeners();
  }

  getRealTimeStockData() {
    for (var stock in stockList) {
      final message = {'type': 'subscribe', 'symbol': stock};
      channel.sink.add(jsonEncode(message));
    }

    _streamSubscription = channel.stream.listen((event) {
      //log('event: $event');
      final data = jsonDecode(event);

      if (data['data'][0] != null) {
        final stock = Stock.fromJson2(data);
        stocksMap.update(stock.symbol, (value) => stock, ifAbsent: () => stock);
        notifyListeners();
      }
      //log(stock.toString());
    });
  }

  StockDataProviderV2() {
    _initialFetch();
    Future.delayed(const Duration(milliseconds: 300), getRealTimeStockData());
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
    _streamSubscription.cancel();
    channel.sink.close();
  }
}
