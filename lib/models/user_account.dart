class UserAccountModel {
  final num balance;
  // final Map<String, dynamic> portfolio;
//  final Map<String, Stock> stocks;

//  double get balance => _balance;

  factory UserAccountModel.fromJson(Map<String, dynamic> json) {
    return UserAccountModel(
        balance: json['balance'] /* , portfolio: json['portfolio'] */);
  }

  UserAccountModel({required this.balance /* , required this.portfolio */});
}
