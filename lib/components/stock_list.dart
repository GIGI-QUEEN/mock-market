import 'package:flutter/material.dart';
import 'package:stock_market/components/stock_logo.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/utils/utils.dart';
import 'package:stock_market/views/historical.dart';

class StockListView extends StatelessWidget {
  const StockListView({super.key, required this.stocksMap});
  final Map<String, Stock> stocksMap;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      //itemCount: stocksMap.length,
      itemCount: 2,

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
      ),
    );
  }
}
