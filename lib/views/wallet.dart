import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/providers/account_provider.dart';
import 'package:stock_market/utils/utils.dart';
import '../services/database.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  WalletPageState createState() => WalletPageState();
}

class WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    //final accountModel = context.watch<AccountProvider>();
    final accountModel = Provider.of<AccountProvider>(context);
    accountModel.loadDataV2();
    log('p: ${accountModel.portfolio}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
      ),
      body: PortfolioList(),
    );
  }
}

class PortfolioList extends StatelessWidget {
  const PortfolioList({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('aaa');
  }
}
/*  Widget _buildPortfolioList() {
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
  } */