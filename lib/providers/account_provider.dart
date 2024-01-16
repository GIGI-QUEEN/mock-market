import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/models/user_account.dart';
import 'package:stock_market/services/database.dart';
import 'package:stock_market/services/network.dart';

class AccountProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();
  UserAccountModel? accountData;
  Map<String, int> _portfolio = {};
  Map<String, int> get portfolio => _portfolio;
  final NetworkService _networkService = NetworkService();
  final Map<String, Stock> _userStocksMap = {};
  Map<String, Stock> get userStocksMap => _userStocksMap;

  /*  Future<void> loadDataV2() async {
    if (_auth.currentUser != null) {
      _portfolio = await _databaseService.getPortfolio(_auth.currentUser!);
    }
  } */

  void listenToAccountChanges() {
    if (_auth.currentUser != null) {
      _databaseService
          .listenToUserAccountData(_auth.currentUser!)
          .listen((event) {
        final data = event.data();
        // _networkService.fetch20Stocks();

        if (data != null) {
          accountData = UserAccountModel.fromJson(data);
          notifyListeners();
        }
      });
    }
  }

  void getUserStocksData() async {
    _portfolio = await _databaseService.getPortfolio(_auth.currentUser!);

    for (var entry in _portfolio.entries) {
      final stockPrice = await _networkService.fetchSymbol(entry.key);
      final symbol = entry.key;
      final qty = entry.value;
      final userStock = Stock(
        price: stockPrice,
        symbol: symbol,
        time: DateTime.now(),
        quantity: qty,
        totalValue: stockPrice * qty,
      );
      userStocksMap.update(userStock.symbol, (value) => userStock,
          ifAbsent: () => userStock);
      //log('user stock: $userStock');
    }
    log('user stocks: $userStocksMap');
    notifyListeners();
  }

  AccountProvider() {
    getUserStocksData();
    listenToAccountChanges();
  }
}
