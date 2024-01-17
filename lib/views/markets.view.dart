import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/components/stock_list.dart';
import 'package:stock_market/constants/fake_stocks_map.dart';
import 'package:stock_market/providers/stock_data_provider.dart';

class MarketsView extends StatelessWidget {
  const MarketsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: ChangeNotifierProvider(
          create: (context) => StockDataProviderV2(),
          child: Consumer<StockDataProviderV2>(builder: (context, model, _) {
            final stocksMap = model.isLoading ? fakeStockMap : model.stocksMap;
            // final itemCount = stocksMap.length >= 2 ? 2 : 0;
            return StockListView(
                itemCount: stocksMap.length,
                stocksMap: stocksMap,
                isLoading: model.isLoading);
          }),
        ),
      ),
    );
  }
}
