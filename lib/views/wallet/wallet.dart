import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stock_market/components/stock_list.dart';
import 'package:stock_market/constants/fake_stocks_map.dart';
import 'package:stock_market/providers/account_provider.dart';
import 'package:stock_market/utils/utils.dart';

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
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: ChangeNotifierProvider(
          create: (context) => AccountProvider(),
          child: Consumer<AccountProvider>(builder: (context, model, _) {
            //final stocksMap = model.userStocksMap;
            final stocksMap =
                model.isLoading ? fakeStockMap : model.userStocksMap;
            return Skeletonizer(
              enabled: model.isLoading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Total stocks value',
                        style: TextStyle(
                            color: Color.fromARGB(255, 112, 112, 112),
                            fontSize: 12),
                      ),
                      Text(
                        "\$${formatNumber(model.totalStocksValue)}",
                        style: GoogleFonts.openSans(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
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
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
