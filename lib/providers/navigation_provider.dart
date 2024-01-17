import 'package:flutter/material.dart';
import 'package:stock_market/constants/routes_names.dart';
import 'package:stock_market/views/markets.view.dart';
import 'package:stock_market/views/home.view.dart';
import 'package:stock_market/views/settings.view.dart';
import 'package:stock_market/views/wallet/wallet.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentPageIndex = 0;
  int get currentPageIndex => _currentPageIndex;

  Widget _currentView = const HomeView();
  Widget get currentView => _currentView;

  final Map<String, Widget> _screensMap = {
    home: const HomeView(),
    wallet: const WalletPage(),
    markets: const MarketsView(),
    settings: const SettingsView(),
  };

  Map<String, Widget> get screensMap => _screensMap;

  //changes the view and keeps bottom navigation bar tabs
  void changeView(String routeName) {
    _currentPageIndex = _screensMap.entries
        .toList()
        .indexWhere((element) => element.key == routeName);
    _currentView = _screensMap[routeName]!;
    notifyListeners();
  }
}
