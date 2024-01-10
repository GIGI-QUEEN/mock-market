import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/components/stock_list.dart';
import 'package:stock_market/components/wallet_summary_card.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stock_market/views/historical.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:stock_market/models/stock.dart';
import 'package:stock_market/providers/stock_data_provider.dart';
import 'package:stock_market/services/network.dart';

final String? token = dotenv.env['FINNHUB_TOKEN'];

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://ws.finnhub.io?token=$token'),
  );
  late StreamSubscription _streamSubscription;
  final Map<String, Stock> stocksMap = {};

  getRealTimeStockData() {
    for (var stock in stockList) {
      final message = {'type': 'subscribe', 'symbol': stock};
      channel.sink.add(jsonEncode(message));
    }

    _streamSubscription = channel.stream.listen((event) {
      final data = jsonDecode(event);
      final stock = Stock.fromJson2(data);
      setState(() {
        stocksMap.update(stock.symbol, (value) => stock, ifAbsent: () => stock);
      });
    });
  }

  closeStream() {
    channel.sink.close();
  }

  @override
  void initState() {
    getRealTimeStockData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamSubscription.cancel();
    closeStream();
    super.dispose();
  }

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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            WalletSummaryCard(),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Watchlist',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'See all',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(child: StockListView(stocksMap: stocksMap)),
          ],
        ),
        // child: StockListView(stocksMap: stocksMap),
      ),
    );
  }
}
