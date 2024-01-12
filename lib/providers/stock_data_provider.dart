import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stock_market/constants/stock_list.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/services/network.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StocksDataProvider extends ChangeNotifier {
  final Map<String, Stock> _stocksMap = {};
  Map<String, Stock> get stocksMap => _stocksMap;

  final channel = WebSocketChannel.connect(
    Uri.parse('wss://ws.finnhub.io?token=$token'),
  );
  late StreamSubscription _streamSubscription;
  //final Map<String, Stock> stocksMap = {};

  getRealTimeStockData() {
    for (var stock in stockList) {
      final message = {'type': 'subscribe', 'symbol': stock};
      channel.sink.add(jsonEncode(message));
    }

    _streamSubscription = channel.stream.listen((event) {
      final data = jsonDecode(event);
      final stock = Stock.fromJson2(data);
      _stocksMap.update(stock.symbol, (value) => stock, ifAbsent: () => stock);
      notifyListeners();
      /*  setState(() {
        stocksMap.update(stock.symbol, (value) => stock, ifAbsent: () => stock);
      }); */
    });
  }

  closeStream() {
    channel.sink.close();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamSubscription.cancel();
    closeStream();
    super.dispose();
  }

  /*  StocksDataProvider() {
    getRealTimeStockData();
  } */
}
