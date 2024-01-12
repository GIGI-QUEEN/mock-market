import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/services/network.dart';

class StocksDataProvider extends ChangeNotifier {
  Map<String, Stock> stocksData = {};
  late StreamSubscription _streamSubscription;
  final NetworkService _networkService = NetworkService();

  get stocksMap => null;

  /*  void listenToStream() {
    final stream = _networkService.getRealTimeStockData();

    _streamSubscription = stream.listen((event) {
      // log('event: $event');
      final data = jsonDecode(event);

      final stock = Stock.fromJson2(data);
      stocksData.update(stock.symbol, (value) => stock, ifAbsent: () => stock);
      //log(stocksData.toString());
      notifyListeners();
    });
  } */

  void convertStreamData() {}

  @override
  void dispose() {
    // TODO: implement dispose
    //_streamSubscription.cancel();
    super.dispose();
  }

  void updateStocksMap(Map<String, Stock> map) {}

  /*  StocksDataProvider() {
    listenToStream();
  } */
}
