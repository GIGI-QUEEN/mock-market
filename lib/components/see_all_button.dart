import 'package:flutter/material.dart';

class SeeAllButton extends StatelessWidget {
  const SeeAllButton({super.key, this.onPressed});
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Text(
          'See all',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ));
  }
}
