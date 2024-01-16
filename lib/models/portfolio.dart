import 'package:stock_market/models/stock.dart';

class Portfolio {
  final Map<String, Stock> userStocks;

  /*  factory Portfolio.fromFirestore(Map<String, dynamic> data) {
    return Portfolio(userStocks: data['']);
  } */

  Portfolio({required this.userStocks});
}
