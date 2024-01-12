import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/services/database.dart';
import 'package:stock_market/utils/utils.dart';
import 'package:stock_market/views/buy.dart';

/* final DatabaseService _databaseService = DatabaseService();
final _auth = FirebaseAuth.instance; */

class BuyButton extends StatelessWidget {
  final String stockSymbol;
  final DatabaseService _databaseService = DatabaseService();
//final _auth = FirebaseAuth.instance;

  BuyButton({Key? key, required this.stockSymbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    String company = getCompanyName(stockSymbol);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: MaterialButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => NumberInputView(
              onNumberSubmitted: (number) {
                int amount = int.parse(number);
                if (firebaseUser != null) {
                  _databaseService.buy(
                    firebaseUser,
                    amount,
                    1.2, // todo: realtime
                    stockSymbol,
                  );
                }
              },
            ),
          );
        },
        color: const Color(0xFF22CC9E),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Text(
          'Buy $company',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
