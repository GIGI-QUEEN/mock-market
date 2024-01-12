import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_market/components/stock_logo.dart';
import 'package:stock_market/models/stock.dart';

class StockCard extends StatelessWidget {
  const StockCard({super.key, required this.stock});

  final Stock stock;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color.fromARGB(255, 226, 226, 226)),
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
                    Border.all(color: Color.fromARGB(255, 226, 226, 226)),
                //  mainContainerBgColor: Color.fromARGB(127, 233, 233, 233),
              ),
              Text(
                '\$3,200.80',
                style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
              )
            ],
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
              Text(
                '+0.66%',
                style: GoogleFonts.openSans(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
