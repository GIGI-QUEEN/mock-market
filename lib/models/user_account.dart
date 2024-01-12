import 'package:stock_market/models/stock.dart';
import 'package:stock_market/services/network.dart';

class UserAccountModel {
  final num balance;
//  final Map<String, Stock> stocks;

//  double get balance => _balance;

  factory UserAccountModel.fromJson(Map<String, dynamic> json) {
    return UserAccountModel(balance: json['balance']);
  }

  UserAccountModel({required this.balance});
}
