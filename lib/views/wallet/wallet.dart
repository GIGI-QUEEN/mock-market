import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stock_market/components/stock_list.dart';
import 'package:stock_market/providers/account_provider.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  WalletPageState createState() => WalletPageState();
}

class WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ChangeNotifierProvider(
          create: (context) => AccountProvider(),
          child: Consumer<AccountProvider>(builder: (context, model, _) {
            //final stocksMap = model.userStocksMap;
            final stocksMap =
                model.isLoading ? fakeStockMap : model.userStocksMap;
            return Skeletonizer(
              enabled: model.isLoading,
              child: ListView.separated(
                itemCount: stocksMap.length,
                //itemCount: 2,
                itemBuilder: (context, index) {
                  final stock = stocksMap.values.elementAt(index);
                  // log(stock.toString());
                  return StockTile(stock: stock);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
