import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_market/models/user_account.dart';

class DatabaseService {
  final _database = FirebaseFirestore.instance;
  //final _auth = FirebaseAuth.instance;

  // call when adding new user, pass in emailcontroller text
  Future<void> addUser(User user) async {
    try {
      DocumentReference userRef = _database.collection('users').doc(user.uid);
      // String uid = userRef.id;

      await userRef.set({
        "uid": user.uid,
        "email": user.email,
        "balance": 1000000,
      });
    } catch (e) {
      log('Error in addUser function: $e');
      throw Exception(e);
    }
  }

  // call to get the remaining balance
  Future<double> getBalance(User user) async {
    late double balance;
    try {
      DocumentSnapshot userSnapshot =
          await _database.collection('users').doc(user.uid).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        balance = userData['balance']?.toDouble() ?? 0.0;
        return balance;
      } else {
        // if document doesn't exist
        return 0.0;
      }
    } catch (e) {
      log('Error in getBalance function: $e');
      throw Exception(e);
    }
  }

  // sets user's balance, takes both negative and positive double (sale/acquisition)
  Future<void> setBalance(User user, double transactionSum) async {
    try {
      String currentUserUid = user.uid;
      DocumentReference userRef =
          _database.collection('users').doc(currentUserUid);

      await _database.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userRef);
        double currentBalance = snapshot['balance']?.toDouble() ?? 0.0;

        double newBalance = currentBalance + transactionSum;

        transaction.update(userRef, {'balance': newBalance});
      });
    } catch (e) {
      log('Error in setBalance function: $e');
      throw Exception(e);
    }
  }

  // call to get the portfolio
  Future<Map<String, int>> getPortfolio(User user) async {
    try {
      QuerySnapshot portfolioSnapshot = await _database
          .collection('users')
          .doc(user.uid)
          .collection('portfolio')
          .get();

      Map<String, int> portfolioData = {};

      for (var doc in portfolioSnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('amount')) {
          int amount = data['amount'] as int;
          portfolioData[doc.id] = amount;
        } else {
          return {};
        }
      }
      log('portfolioData: $portfolioData');
      return portfolioData;
    } catch (e) {
      log('Error in getPortfolio function: $e');
      throw Exception(e);
    }
  }

  // sell stocks, returns true if the transaction suceeded, false if not
  Future<bool> sell(
    User user,
    int amount,
    double rate,
    String stockName,
    double timestamp,
  ) async {
    log('in sell');
    try {
      String currentUserUid = user.uid;
      String timestampString = timestamp.toString();

      DocumentReference salesRef = _database
          .collection('users')
          .doc(currentUserUid)
          .collection('sales')
          .doc(timestampString);

      await salesRef.set({
        "amount": amount,
        "rate": rate,
        "stockName": stockName,
        "symbol": "USD",
        "timestamp": timestamp,
      });
      double transactionSum = rate * amount;
      setBalance(user, transactionSum);
      return true;
    } catch (e) {
      log('Error in sell function: $e');
      throw Exception(e);
    }
  }

  // buy stocks, returns true if the transaction suceeded, false if not
  Future<bool> buy(
    User user,
    int amount,
    double rate,
    String stockName,
    double timestamp,
  ) async {
    try {
      log('in buy');
      String currentUserUid = user.uid;
      String timestampString = timestamp.toString();
      double transactionSum = rate * amount;
      double balance = await getBalance(user);

      if (balance >= transactionSum) {
        DocumentReference salesRef = _database
            .collection('users')
            .doc(currentUserUid)
            .collection('purchases')
            .doc(timestampString);

        await salesRef.set({
          "amount": amount,
          "rate": rate,
          "stockName": stockName,
          "symbol": "USD",
          "timestamp": timestamp,
        });
        await setBalance(user, -transactionSum);
        return true;
      } else {
        log('not enough \$\$\$');
        return false;
      }
    } catch (e) {
      log('Error in buy function: $e');
      throw Exception(e);
    }
  }

/*   Future<UserAccountModel> listenToUserAccountData(User user) async {
    UserAccountModel accData = UserAccountModel(balance: 0);

    _database.collection('users').doc(user.uid).snapshots().listen((event) {
      //log('event: ${event}');
      final data = event.data();
      if (data != null) {
        accData = UserAccountModel.fromJson(data);
        log('b: ${accData.balance}');
      }
    });
    return accData;
  } */
  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToUserAccountData(
      User user) {
    return _database.collection('users').doc(user.uid).snapshots();
  }
}
