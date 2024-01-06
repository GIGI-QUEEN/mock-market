import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
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
      throw Exception(e);
    }
  }

  // call when you want to get the remaining balance
  Future<double> getBalance() async {
    log('in getBalance');
    late double balance;
    try {
      DocumentSnapshot userSnapshot =
          await _database.collection('users').doc(_auth.currentUser!.uid).get();

      if (userSnapshot.exists) {
        log('have the snapshot');
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        log('userdata: $userData');
        balance = userData['balance']?.toDouble() ?? 0.0;
        log('balance: $balance'.toString());
        return balance;
      } else {
        // if document doesn't exist
        return 0.0;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
