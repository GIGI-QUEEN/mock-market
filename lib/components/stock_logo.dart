import 'package:flutter/material.dart';

class StockLogo extends StatelessWidget {
  const StockLogo(
      {super.key,
      required this.stockSymbol,
      required this.mainContainerSize,
      required this.imageContainerSize,
      this.mainContainerBgColor,
      this.mainContainerBorder});
  final String stockSymbol;
  final double mainContainerSize;
  final double imageContainerSize;
  final Color? mainContainerBgColor;
  final Border? mainContainerBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mainContainerSize,
      height: mainContainerSize,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: mainContainerBorder,
        shape: BoxShape.circle,
        color: mainContainerBgColor ?? Colors.white,
      ),
      child: Container(
        /*   width: imageContainerSize,
        height: imageContainerSize, */
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            'assets/logos/${stockSymbol.toLowerCase()}.png',
          ),
        )),
      ),
    );
  }
}
