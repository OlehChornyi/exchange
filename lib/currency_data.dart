import 'dart:convert';
import 'package:http/http.dart' as http;

const currencyAPIURL = 'https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=';

class CurrencyData {
  Future getCurrencyData (int code) async {
    List currencyPrices = [];
    String requestUrl = '$currencyAPIURL$code';
    http.Response response = await http.get(Uri.parse(requestUrl));

    if (response.statusCode ==200) {
      var decodedData = jsonDecode(response.body);
      currencyPrices = decodedData;
    } else {
      print(response.statusCode);
      throw 'Problem with the get request';
    }
    return currencyPrices;
  }
}
