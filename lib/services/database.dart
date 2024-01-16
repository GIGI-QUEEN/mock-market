import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
  Future<num> getBalance(User user) async {
    late num balance;
    try {
      DocumentSnapshot userSnapshot =
          await _database.collection('users').doc(user.uid).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
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

  // sets user's balance, takes both negative and positivenum (sale/acquisition)
  Future<void> setBalance(User user, num transactionSum) async {
    try {
      String currentUserUid = user.uid;
      DocumentReference userRef =
          _database.collection('users').doc(currentUserUid);

      await _database.runTransaction((transaction) async {
        log('in runTransaction');
        DocumentSnapshot snapshot = await transaction.get(userRef);
        //num currentBalance = snapshot['balance']?.toDouble() ?? 0.0;
        num currentBalance = snapshot['balance'] ?? 0.0;

        num newBalance = currentBalance + transactionSum;

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
      //log('portfolioData: $portfolioData');
      return portfolioData;
    } catch (e) {
      log('Error in getPortfolio function: $e');
      throw Exception(e);
    }
  }

  // add stocks to portfolio
  Future<void> addToPortfolio(User user, String stockName, num amount) async {
    try {
      String currentUserUid = user.uid;

      DocumentReference portfolioRef = _database
          .collection('users')
          .doc(currentUserUid)
          .collection('portfolio')
          .doc(stockName);

      DocumentSnapshot portfolioSnapshot = await portfolioRef.get();
      if (portfolioSnapshot.exists) {
        // if this stock already exists in portfolio, its amount is updated
        int existingAmount = portfolioSnapshot.get('amount') as int;
        num newAmount = existingAmount + amount;

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
  Future<void> removeFromPortfolio(
      User user, String stockName, num amount) async {
    try {
      log('in removeFromPortfolio');
      String currentUserUid = user.uid;

      DocumentReference portfolioRef = _database
          .collection('users')
          .doc(currentUserUid)
          .collection('portfolio')
          .doc(stockName);

      DocumentSnapshot portfolioSnapshot = await portfolioRef.get();
      if (portfolioSnapshot.exists) {
        int existingAmount = portfolioSnapshot.get('amount') as int;

        if (existingAmount > amount) {
          await portfolioRef.update({
            "amount": existingAmount - amount,
          });
        } else {
          await portfolioRef.delete();
        }
      } else {
        log('Stock $stockName not found in portfolio.');
      }
    } catch (e) {
      log('Error in removeFromPortfolio function: $e');
      throw Exception(e);
    }
  }

  // sell stocks, returns true if the transaction suceeded, false if not
  Future<bool> sell(
    User user,
    num amount,
    num rate,
    String stockName,
  ) async {
    try {
      log('in sell');
      String currentUserUid = user.uid;
      Timestamp timestamp = Timestamp.now();
      DateTime dateTime = timestamp.toDate();
      String formattedDate =
          DateFormat('MMM dd, yyyy, hh:mm:ss a').format(dateTime);

      num transactionSum = rate * amount;
      Map<String, int> stocks = await getPortfolio(user);
      if (stocks.containsKey(stockName) && stocks[stockName]! >= amount) {

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
        setBalance(user, transactionSum);
        await removeFromPortfolio(user, stockName, amount);
        return true;
      } else {
        log('transaction failed');
        return false;
      }
    } catch (e) {
      log('Error in sell function: $e');
      throw Exception(e);
    }
  }

  // buy stocks, returns true if the transaction suceeded, false if not
  Future<bool> buy(
    User user,
    num amount,
    num rate,
    String stockName,
  ) async {
    try {
      log('in buy');
      String currentUserUid = user.uid;
      Timestamp timestamp = Timestamp.now();
      DateTime dateTime = timestamp.toDate();
      String formattedDate =
          DateFormat('MMM dd, yyyy, hh:mm:ss a').format(dateTime);
      num transactionSum = rate * amount;
      num balance = await getBalance(user);

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
        await setBalance(user, -transactionSum);
        await addToPortfolio(user, stockName, amount);
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
