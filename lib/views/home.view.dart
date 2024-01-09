import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/providers/stock_data_provider.dart';
import 'package:stock_market/services/network.dart';
import 'package:stock_market/utils/utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
//  NetworkService _networkService = NetworkService();
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://ws.finnhub.io?token=$token'),
  );
  late StreamSubscription _streamSubscription;
  final Map<String, Stock> stocksMap = {};

  getRealTimeStockData() {
    final aapl = {'type': 'subscribe', 'symbol': 'AAPL'};
    final amzn = {'type': 'subscribe', 'symbol': 'AMZN'};
    final tsla = {'type': 'subscribe', 'symbol': 'TSLA'};
    final msft = {'type': 'subscribe', 'symbol': 'MSFT'};
    final nvda = {'type': 'subscribe', 'symbol': 'NVDA'};
    final googl = {'type': 'subscribe', 'symbol': 'GOOGL'};
    final meta = {'type': 'subscribe', 'symbol': 'META'};
    final brk = {'type': 'subscribe', 'symbol': 'BRK.B'};
    final visa = {'type': 'subscribe', 'symbol': 'V'};
    final ma = {'type': 'subscribe', 'symbol': 'MA'};
    final nflx = {'type': 'subscribe', 'symbol': 'NFLX'};

    channel.sink.add(jsonEncode(aapl));
    channel.sink.add(jsonEncode(amzn));
    channel.sink.add(jsonEncode(tsla));
    channel.sink.add(jsonEncode(msft));
    channel.sink.add(jsonEncode(nvda));
    channel.sink.add(jsonEncode(googl));
    channel.sink.add(jsonEncode(meta));
    channel.sink.add(jsonEncode(brk));
    channel.sink.add(jsonEncode(visa));
    channel.sink.add(jsonEncode(ma));
    channel.sink.add(jsonEncode(nflx));

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
        title: const Text(
          'Hi, James Smith',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView.separated(
          itemCount: stocksMap.length,
          itemBuilder: (context, index) {
            final stock = stocksMap.values.elementAt(index);
            // log(stock.toString());
            return Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 240, 240, 240),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Container(
                    width: 35,
                    height: 35,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(
                        'assets/logos2/${stock.symbol.toLowerCase()}.png',
                      ),
                    )),
                  ),
                ),
                title: Text(
                  getCompanyName(stock.symbol),
                  style: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${stock.price.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 10,
            );
          },
        ),
      ),
    );
  }
}
