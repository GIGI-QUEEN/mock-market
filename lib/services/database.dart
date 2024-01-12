import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final _database = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // call when adding new user, pass in emailcontroller text
  Future<void> addUser(String email) async {
    try {
      DocumentReference userRef = _database.collection('users').doc();
      String uid = userRef.id;

      await userRef.set({
        "uid": uid,
        "email": email,
        "balance": 1000000,
      });
    } catch (e) {
      log('Error in addUser function: $e');
      throw Exception(e);
    }
  }

  // call to get the remaining balance
  Future<double> getBalance() async {
    late double balance;
    try {
      log('in getBalance');
      DocumentSnapshot userSnapshot =
          await _database.collection('users').doc(_auth.currentUser!.uid).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        // balance = userData['balance']?.toDouble() ?? 0.0;
        balance = userData['balance'] ?? 0.0;
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
  Future<void> setBalance(double transactionSum) async {
    try {
      log('in setBalance');
      String currentUserUid = _auth.currentUser!.uid;
      DocumentReference userRef =
          _database.collection('users').doc(currentUserUid);

      await _database.runTransaction((transaction) async {
        log('in runTransaction');
        DocumentSnapshot snapshot = await transaction.get(userRef);
        // double currentBalance = snapshot['balance']?.toDouble() ?? 0.0;
        double currentBalance = snapshot['balance'] ?? 0.0;

        double newBalance = currentBalance + transactionSum;

        transaction.update(userRef, {'balance': newBalance});
      });
    } catch (e) {
      log('Error in setBalance function: $e');
      throw Exception(e);
    }
  }

  // call to get the portfolio
  Future<Map<String, int>> getPortfolio() async {
    try {
      QuerySnapshot portfolioSnapshot = await _database
          .collection('users')
          .doc(_auth.currentUser!.uid)
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

  // add stocks to portfolio
  Future<void> addToPortfolio(String stockName, int amount) async {
    try {
      String currentUserUid = _auth.currentUser!.uid;

      DocumentReference portfolioRef = _database
          .collection('users')
          .doc(currentUserUid)
          .collection('portfolio')
          .doc(stockName);

      DocumentSnapshot portfolioSnapshot = await portfolioRef.get();
      if (portfolioSnapshot.exists) {
        // if this stock already exists in portfolio, its amount is updated
        int existingAmount = portfolioSnapshot.get('amount') as int;
        int newAmount = existingAmount + amount;

        await portfolioRef.update({
          "amount": newAmount,
        });
      } else {
        await portfolioRef.set({
          "amount": amount,
        });
      }
    } catch (e) {
      log('Error in addToPortfolio function: $e');
      throw Exception(e);
    }
  }

  // remove stocks from portfolio
  Future<void> removeFromPortfolio(String stockName) async {
    try {
      String currentUserUid = _auth.currentUser!.uid;

      DocumentReference portfolioRef = _database
          .collection('users')
          .doc(currentUserUid)
          .collection('portfolio')
          .doc(stockName);

      await portfolioRef.delete();
    } catch (e) {
      log('Error in removeFromPortfolio function: $e');
      throw Exception(e);
    }
  }

  // sell stocks, returns true if the transaction suceeded, false if not
  Future<bool> sell(
    int amount,
    double rate,
    String stockName,
  ) async {
    log('in sell');
    try {
      String currentUserUid = _auth.currentUser!.uid;
      Timestamp timestamp = Timestamp.now();
      DateTime dateTime = timestamp.toDate();
      String formattedDate =
          DateFormat('MMM dd, yyyy, hh:mm:ss a').format(dateTime);
      DocumentReference salesRef = _database
          .collection('users')
          .doc(currentUserUid)
          .collection('sales')
          .doc(formattedDate);

      await salesRef.set({
        "amount": amount,
        "rate": rate,
        "stockName": stockName,
        "symbol": "USD",
        "timestamp": formattedDate,
      });
      double transactionSum = rate * amount;
      setBalance(transactionSum);
      return true;
    } catch (e) {
      log('Error in sell function: $e');
      throw Exception(e);
    }
  }

  // buy stocks, returns true if the transaction suceeded, false if not
  Future<bool> buy(
    int amount,
    double rate,
    String stockName,
  ) async {
    try {
      log('in buy');
      String currentUserUid = _auth.currentUser!.uid;
      Timestamp timestamp = Timestamp.now();
      DateTime dateTime = timestamp.toDate();
      String formattedDate =
          DateFormat('MMM dd, yyyy, hh:mm:ss a').format(dateTime);
      double transactionSum = rate * amount;
      double balance = await getBalance();

      if (balance >= transactionSum) {
        DocumentReference salesRef = _database
            .collection('users')
            .doc(currentUserUid)
            .collection('purchases')
            .doc(formattedDate);

        await salesRef.set({
          "amount": amount,
          "rate": rate,
          "stockName": stockName,
          "symbol": "USD",
          "timestamp": timestamp,
        });
        await setBalance(-transactionSum);
        await addToPortfolio(stockName, amount);
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
}
