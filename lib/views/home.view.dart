import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/components/see_all_button.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:stock_market/components/stock_list.dart';
import 'package:stock_market/components/wallet_summary_card.dart';

final String? token = dotenv.env['FINNHUB_TOKEN'];

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          firebaseUser != null ? 'Hi, ${firebaseUser.email!}' : '',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: const Column(
          children: [
            WalletSummaryCard(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Portfolio',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SeeAllButton(),
              ],
            ),
            /*    stocksMap.isNotEmpty
                ? Expanded(
                    child: ListView(
                      // This next line does the trick.
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        StockCard(
                          stock: stocksMap['AAPL']!,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        StockCard(stock: stocksMap['TSLA']!),
                        const SizedBox(
                          width: 20,
                        ),
                        StockCard(stock: stocksMap['AMZN']!),
                      ],
                    ),
                  )
                : Text(''), */
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Watchlist',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SeeAllButton(),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(child: StockListView()),

            // Expanded(child: StockListView(stocksMap: stocksMap)),
          ],
        ),
        // child: StockListView(stocksMap: stocksMap),
      ),
    );
  }
}
