import 'dart:async';
import 'dart:developer';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/components/centered_circular_progress_indicator.dart';
import 'package:stock_market/components/sell_button.dart';
import 'package:stock_market/components/stock_logo.dart';
import 'package:stock_market/providers/single_stock_data_provider.dart';
import 'package:stock_market/services/charts.dart';
import 'package:stock_market/utils/utils.dart';
import 'package:stock_market/views/stock_historical/historical_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

import 'package:stock_market/services/network.dart';
import 'package:stock_market/components/buy_button.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/providers/stock_data_provider.dart';

class StockHistoricalView extends StatelessWidget {
  const StockHistoricalView({
    super.key,
    required this.stock,
  });
  final Stock stock;

  @override
  Widget build(BuildContext context) {
    List<String> durations = ['7d', '1m', '3m', '6m', '1y', '60y'];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            StockLogo(
                stockSymbol: stock.symbol,
                mainContainerSize: 50,
                imageContainerSize: 25),
            Expanded(
              child: Text(
                getCompanyName(stock.symbol),
                softWrap: false,
                maxLines: 1,
                style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
                overflow: TextOverflow.fade,
              ),
            )
          ],
        ),
      ),
      body: ChangeNotifierProvider<SingleStockDataProvider>(
        create: (context) => SingleStockDataProvider(stock: stock),
        child: Consumer<SingleStockDataProvider>(
          builder: (context, model, _) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Price per Unit',
                            style: TextStyle(
                                color: Color.fromARGB(255, 112, 112, 112)),
                          ),
                          Text(
                            "\$${formatNumber(stock.price)}",
                            style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ],
                      ),
                      ToggleButtons(
                        onPressed: (int index) => model.switchChart(index),
                        isSelected: model.selectedChart,
                        borderRadius: BorderRadius.circular(10),
                        children: chartIcons,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  model.chartData.isEmpty
                      ? const CenteredCircularProgressIndicator()
                      : HistoricalChart(
                          showCandlestickChart: model.showCanglestickChart,
                          stock: model.stock,
                          trackballBehavior: model.trackballBehavior ??
                              TrackballBehavior(enable: false),
                          chartData: model.chartData),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 15),
                    height: 40,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final duration = durations[index];
                          return SwitchPeriodButton(
                              onPressed: () async =>
                                  model.fetchDataForDuration(duration),
                              label: duration,
                              isSelected: model.currentPeriod == duration);
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                              width: 5,
                            ),
                        itemCount: 6),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BuyButton(stock: stock),
                  SellButton(
                    stock: stock,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

const chartIcons = [
  Icon(
    Icons.show_chart,
    size: 20,
  ),
  Icon(
    Icons.candlestick_chart,
    size: 20,
  )
];

class SwitchPeriodButton extends StatelessWidget {
  const SwitchPeriodButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.isSelected,
  });
  final Function()? onPressed;
  final String label;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 50,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? Theme.of(context).primaryColor : null,
          foregroundColor: isSelected ? Colors.white : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(label == '60y' ? 'All' : label.toUpperCase()),
      ),
    );
  }
}

class ChartSampleData {
  ChartSampleData({this.x, this.open, this.close, this.low, this.high});
  final DateTime? x;
  final num? open;
  final num? close;
  final num? low;
  final num? high;
}
