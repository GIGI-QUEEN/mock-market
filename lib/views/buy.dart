import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/providers/stock_data_provider.dart';

class NumberInputView extends StatefulWidget {
  final Function(String) onNumberSubmitted;

  const NumberInputView({Key? key, required this.onNumberSubmitted})
      : super(key: key);

  @override
  State<NumberInputView> createState() => _NumberInputViewState();
}

class _NumberInputViewState extends State<NumberInputView> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  String enteredNumber = '';

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        enteredNumber = controller.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    focusNode.requestFocus();

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Enter Amount',
            ),
            onSubmitted: (value) {
              widget.onNumberSubmitted(value);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
