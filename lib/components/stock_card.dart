import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_market/components/minigraph.dart';
import 'package:stock_market/components/stock_logo.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/services/charts.dart';
import 'package:stock_market/utils/utils.dart';
import 'package:stock_market/views/stock_historical/historical.dart';

class StockCard extends StatelessWidget {
  StockCard({
    super.key,
    required this.stock,
  });

  final Stock stock;
  late Future<List<ChartSampleData>> _chartData;

  final ChartsService _chartsService = ChartsService();

  Future<List<ChartSampleData>> fetchGraphData(
      String stockSymbol, String duration) async {
    _chartData = _chartsService.getChartData(stockSymbol, duration);
    return _chartData;
  }

  @override
  Widget build(BuildContext context) {
    _chartData = fetchGraphData(stock.symbol, "60d");
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromARGB(255, 226, 226, 226)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StockLogo(
                stockSymbol: stock.symbol,
                mainContainerSize: 38,
                imageContainerSize: 25,
                mainContainerBorder:
                    Border.all(color: const Color.fromARGB(255, 226, 226, 226)),
                //  mainContainerBgColor: Color.fromARGB(127, 233, 233, 233),
              ),
              Text(
                '\$${formatNumber(stock.totalValue)}',
                style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<ChartSampleData>>(
              future: _chartData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return MiniGraph(
                    chartData: snapshot.data!,
                    percentChange: stock.percentChange,
                  );
                } else if (snapshot.hasError) {
                  log('error');
                  return Text('Error fetching chart data: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator(); // todo: skeleton?
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                stock.symbol,
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                ),
              ),
              PercentChange(stock: stock),
            ],
          ),
        ],
      ),
    );
  }
}

class PercentChange extends StatelessWidget {
  const PercentChange({
    super.key,
    required this.stock,
  });

  final Stock stock;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${formatNumber(stock.percentChange)}%',
      style: GoogleFonts.openSans(
        color: stock.percentChange! >= 0
            ? Theme.of(context).primaryColor
            : Colors.red,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
