import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:stock_market/constants/stock_list.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/services/network.dart';

class StockDataProviderV2 extends ChangeNotifier with WidgetsBindingObserver {
  final Map<String, Stock> _stocksMap = {};
  Map<String, Stock> get stocksMap => _stocksMap;
  final NetworkService _networkService = NetworkService();
  late StreamSubscription _streamSubscription;
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://ws.finnhub.io?token=$token'),
  );
  bool _isDisposed = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _initialFetch() async {
    _isLoading = true;
    notifyListeners();

    if (_isDisposed) return;
    for (var stockName in stockList) {
      //final initialPrice = await _networkService.fetchSymbol(stockName);
      final initialStockPriceData =
          await _networkService.fetchSymbolV2(stockName);
      final price = initialStockPriceData['currentPrice'];
      final percentChange = initialStockPriceData['percentChange'];
      if (_isDisposed) return;
      final preFetchedStock = Stock(
        price: price!,
        symbol: stockName,
        time: DateTime.now(),
        percentChange: percentChange,
      );
      /* final preFetchedStock =
          Stock(price: initialPrice, symbol: stockName, time: DateTime.now()); */
      _stocksMap.update(stockName, (value) => preFetchedStock,
          ifAbsent: () => preFetchedStock);
    }
    if (_isDisposed) return;
    _isLoading = false;
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

      if (data['type'] != 'ping') {
        final stock = Stock.fromJson2(data);
        final percentChange = stocksMap[stock.symbol]?.percentChange;
        stock.percentChange = percentChange;
        stocksMap.update(stock.symbol, (value) => stock, ifAbsent: () => stock);
        notifyListeners();
      }
      //log(stock.toString());
    });
  }

  void activateObserver() {
    WidgetsBinding.instance.addObserver(this);

    notifyListeners();
  }

  StockDataProviderV2() {
    activateObserver();
    _initialFetch();
    Future.delayed(const Duration(milliseconds: 300), getRealTimeStockData());
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log('AppLifecycleState: $state');
    notifyListeners();
  }

  @override
  void dispose() {
    log('disposed');
    _isDisposed = true;
    _isLoading = false;
    super.dispose();
    _streamSubscription.cancel();
    channel.sink.close();
    WidgetsBinding.instance.removeObserver(this);
  }
}
