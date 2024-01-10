import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final aapl = {'type': 'subscribe', 'symbol': 'AAPL'};
    final amzn = {'type': 'subscribe', 'symbol': 'AMZN'};
    final tsla = {'type': 'subscribe', 'symbol': 'TSLA'};
    channel.sink.add(jsonEncode(aapl));
    channel.sink.add(jsonEncode(amzn));
    channel.sink.add(jsonEncode(tsla));

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
    //  final stocksModel = Provider.of<StocksDataProvider>(context);
    //stocksModel.listenToStream();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: ListView.builder(
          itemCount: stocksMap.length,
          itemBuilder: (context, index) {
            final stock = stocksMap.values.elementAt(index);
            // log(stock.toString());
            return ListTile(
              title: Text('Symbol: ${stock.symbol}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price: ${stock.price.toStringAsFixed(2)}'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StockHistoricalView(stockSymbol: stock.symbol),
                  ),
                );
              },
            );
          }),
    );
  }
}
