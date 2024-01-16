import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:stock_market/models/user_account.dart';
import 'package:stock_market/services/database.dart';
import 'package:stock_market/services/network.dart';

class AccountProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();
  UserAccountModel? accountData;
  Map<String, int> _portfolio = {};
  Map<String, int> get portfolio => _portfolio;
  // NetworkService _networkService = NetworkService();

  Future<void> loadDataV2() async {
    if (_auth.currentUser != null) {
      _portfolio = await _databaseService.getPortfolio(_auth.currentUser!);
    }
  }

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

  AccountProvider() {
    listenToAccountChanges();
  }
}
