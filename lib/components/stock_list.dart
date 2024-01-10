import 'package:flutter/material.dart';
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
        leading: Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Container(
            width: 35,
            height: 35,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(
                'assets/logos2/${stock.symbol.toLowerCase()}.png',
              ),
            )),
          ),
        ),
        title: Text(
          getCompanyName(stock.symbol),
          style: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\$${stock.price.toStringAsFixed(2)}',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
