import 'package:flutter/material.dart';
import 'package:stock_market/views/home.view.dart';
import 'package:stock_market/views/settings.view.dart';
import 'package:stock_market/views/wallet.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeView(),
    const WalletPage(),
    const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
              icon: Icon(
                Icons.home,
                color:
                    _currentIndex == 0 ? Theme.of(context).primaryColor : null,
              ),
              label: 'home'),
          NavigationDestination(
              icon: Icon(
                Icons.wallet,
                color:
                    _currentIndex == 1 ? Theme.of(context).primaryColor : null,
              ),
              label: 'wallet'),
          NavigationDestination(
              icon: Icon(
                Icons.settings,
                color:
                    _currentIndex == 2 ? Theme.of(context).primaryColor : null,
              ),
              label: 'settings'),
          NavigationDestination(
              icon: Icon(
                Icons.telegram,
                color:
                    _currentIndex == 3 ? Theme.of(context).primaryColor : null,
              ),
              label: 'test'),
        ],
      ),
    );
  }
}
