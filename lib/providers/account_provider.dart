import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:stock_market/models/user_account.dart';
import 'package:stock_market/services/database.dart';
import 'package:stock_market/services/network.dart';

class AccountProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();
  UserAccountModel? accountData;

  void listenToAccountChanges() {
    if (_auth.currentUser != null) {
      _databaseService
          .listenToUserAccountData(_auth.currentUser!)
          .listen((event) {
        final data = event.data();
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
