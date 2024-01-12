import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_market/components/centered_circular_progress_indicator.dart';

String? signUpEmailValidator(String? value) {
  if (value!.isEmpty ||
      !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
    return 'Please enter a valid email';
  }
  return null;
}

String? signUpPasswordValidator(value) {
  if (value!.isEmpty || value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

String? loginEmailValidator(String? value) {
  if (value!.isEmpty) {
    return 'Please, enter email';
  }
  return null;
}

String? loginPasswordValidator(String? value) {
  if (value!.isEmpty) {
    return 'Please, enter password';
  }
  return null;
}

String getCompanyName(String symbol) {
  switch (symbol) {
    case 'GOOGL':
      return 'Google, Inc';
    case 'TSLA':
      return 'Tesla, Inc.';
    case 'MSFT':
      return 'Microsoft Corp.';
    case 'AMZN':
      return 'Amazon.com, Inc.';
    case 'AAPL':
      return 'Apple Inc';
    case 'META':
      return 'Meta Platforms, Inc.';
    case 'BRK.B':
      return 'Berkshire Hathaway Inc. New';
    case 'NVDA':
      return 'Nvidia Corporation';
    case 'V':
      return 'Visa';
    case 'MA':
      return 'Mastercard Incorporated';
    case 'NFLX':
      return 'Netflix, Inc.';
    default:
      return symbol;
  }
}

Widget handleSnapshotState(
    AsyncSnapshot<dynamic> snapshot, Widget widgetToShow) {
  switch (snapshot.connectionState) {
    case ConnectionState.none:
      return const Text('Not loaded');
    case ConnectionState.waiting:
      return const CenteredCircularProgressIndicator();
    case ConnectionState.active:
    case ConnectionState.done:
      if (snapshot.hasData) {
        return widgetToShow;
      } else if (snapshot.hasError) {
        return const Text('error');
      } else {
        return const Text('Not available');
      }
  }
}

String formatNumber(num number) {
  final formatter = NumberFormat("#,###.##");
  return formatter.format(number);
}
