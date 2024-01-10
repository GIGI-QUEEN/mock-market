import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletSummaryCard extends StatelessWidget {
  const WalletSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: decoration,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Wallet Balance',
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            '\$23,245.87',
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 34,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
        Container(
            width: double.infinity,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                gradient: gradient2, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Profit',
                  style: GoogleFonts.openSans(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                Text(
                  '\$12,988.32',
                  style: GoogleFonts.openSans(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

final BoxDecoration decoration =
    BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: gradient);

const LinearGradient gradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      lighterGreen,
      darkerGreen,
    ]);

const LinearGradient gradient2 = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      lighterGreen2,
      darkerGreen2,
    ]);

const lighterGreen = Color.fromRGBO(32, 204, 158, 1);
const darkerGreen = Color.fromRGBO(34, 173, 136, 1);

const lighterGreen2 = Color.fromRGBO(28, 173, 135, 0.377);
const darkerGreen2 = Color.fromRGBO(24, 141, 110, 0.498);
