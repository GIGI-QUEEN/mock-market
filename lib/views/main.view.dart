import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/providers/navigation_provider.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    final navigationModel = Provider.of<NavigationProvider>(context);
    final currentView = navigationModel.currentView;
    final currentIndex = navigationModel.currentPageIndex;
    return Scaffold(
      body: currentView,
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        // selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          final destination =
              navigationModel.screensMap.entries.toList()[index].key;
          navigationModel.changeView(destination);
        },
        destinations: [
          NavigationDestination(
              icon: Icon(
                Icons.home,
                color:
                    currentIndex == 0 ? Theme.of(context).primaryColor : null,
              ),
              label: 'home'),
          NavigationDestination(
              icon: Icon(
                Icons.wallet,
                color:
                    currentIndex == 1 ? Theme.of(context).primaryColor : null,
              ),
              label: 'wallet'),
          NavigationDestination(
              icon: Icon(
                Icons.equalizer,
                color:
                    currentIndex == 2 ? Theme.of(context).primaryColor : null,
              ),
              label: 'markets'),
          NavigationDestination(
              icon: Icon(
                Icons.settings,
                color:
                    currentIndex == 3 ? Theme.of(context).primaryColor : null,
              ),
              label: 'settings'),
        ],
      ),
    );
  }
}
