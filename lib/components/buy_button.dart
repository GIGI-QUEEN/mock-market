import 'package:flutter/material.dart';

class BuyButton extends StatelessWidget {
  final String stockSymbol;

  const BuyButton({Key? key, required this.stockSymbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const  EdgeInsets.symmetric(horizontal: 5.0),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: MaterialButton(
        // 'Buy $stockSymbol',
        onPressed: () {
          // buy logic, numpad?
        },
        color: const Color(0xFF22CC9E),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(14.0),
        ),
        child: Text(
          'Buy $stockSymbol',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
