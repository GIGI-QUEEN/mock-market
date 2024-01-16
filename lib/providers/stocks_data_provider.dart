import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../models/stock.dart';

class StocksProvider extends ChangeNotifier {
  Map<String, Stock> _stocksMap = {};

  final StreamController<String> _priceUpdateController =
      StreamController<String>.broadcast();

  Map<String, Stock> get stocksMap => _stocksMap;

  Stream<String> get priceUpdateStream => _priceUpdateController.stream;

  void updateStocksMap(Map<String, Stock> newStocksMap) {
    _stocksMap = newStocksMap;
    //log('stocksmap: $stocksMap');
    notifyListeners();
  }

  void updateStockPrice(String stockSymbol, double newPrice) {
    if (_stocksMap.containsKey(stockSymbol)) {
      _stocksMap[stockSymbol]!.price = newPrice;
      _priceUpdateController.add(stockSymbol);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceUpdateController.close();
  }
}
