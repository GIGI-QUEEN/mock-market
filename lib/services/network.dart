import 'dart:developer';
import 'package:http/http.dart' as http;

class NetworkService {
  Future<void> fetchStockData(String stockName) async {
    log('in fetchData');
    try {
      var url = Uri.parse('http://127.0.0.1:5001/exchange_rate/$stockName');

      var response = await http.get(url);

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
