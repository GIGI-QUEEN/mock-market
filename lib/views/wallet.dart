import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  WalletPageState createState() => WalletPageState();
}

class WalletPageState extends State<WalletPage> {
  final DatabaseService firebaseService = DatabaseService();
  Map<String, int> _portfolio = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    //final user = context.watch<User?>();
    _portfolio = await firebaseService.getPortfolio();

    log('portfolio: $_portfolio');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
      ),
      body: _buildPortfolioList(),
    );
  }

  Widget _buildPortfolioList() {
    return _portfolio.isEmpty
        ? const Center(
            child: Text('No stocks in portfolio. Go buy your first stock!'))
        : ListView.builder(
            shrinkWrap: true,
            itemCount: _portfolio.length,
            itemBuilder: (context, index) {
              String stock = _portfolio.keys.elementAt(index);
              int quantity = _portfolio.values.elementAt(index);
              return ListTile(
                title: Text(stock),
                subtitle: Text('Quantity: $quantity'),
              );
            },
          );
  }
}
