import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/components/stock_logo.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/providers/stock_data_provider.dart';
import 'package:stock_market/utils/utils.dart';
import 'package:stock_market/views/historical.dart';

class StockListView extends StatelessWidget {
  const StockListView({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StockDataProviderV2(),
      child: Consumer<StockDataProviderV2>(builder: (context, model, _) {
        final stocksMap = model.stocksMap;
        final itemCount = stocksMap.length >= 2 ? 2 : 0;
        return ListView.separated(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final stock = stocksMap.values.elementAt(index);
            return StockTile(stock: stock);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 10,
            );
          },
        );
      }),
    );
  }
}

class StockTile extends StatelessWidget {
  const StockTile({super.key, required this.stock});
  final Stock stock;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 240, 240, 240),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  StockHistoricalView(stockSymbol: stock.symbol),
            ),
          );
        },
        leading: StockLogo(
          stockSymbol: stock.symbol,
          mainContainerSize: 50,
          imageContainerSize: 35,
        ),
        title: Text(
          getCompanyName(stock.symbol),
          style: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\$${formatNumber(stock.price)}',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        trailing: stock.quantity != null && stock.totalValue != null
            ? Column(children: [
                Text('Qty: ${stock.quantity}'),
                Text('\$${formatNumber(stock.totalValue!)}')
              ])
            : null,
      ),
    );
  }
}
