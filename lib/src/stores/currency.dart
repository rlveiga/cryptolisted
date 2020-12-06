import 'dart:convert';

import 'package:Cryptolisted/src/models/currency.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;

part 'currency.g.dart';

class CurrencyStore = CurrencyBase with _$CurrencyStore;

abstract class CurrencyBase with Store {
  @observable
  ObservableList<Currency> currencyList = ObservableList<Currency>();

  @action
  getCurrencyList() async {
    var data = await http.get(
        'https://sandbox-api.coinmarketcap.com/v1/cryptocurrency/listings/latest',
        headers: {'X-CMC_PRO_API_KEY': 'b54bcf4d-1bca-4e8e-9a24-22ff2c3d462c'});

    var jsonData = json.decode(data.body)["data"];

    for (var e in jsonData) {
      Currency currency = Currency(
          e["name"],
          e["symbol"],
          e["quote"]["USD"]["price"] * 5.6,
          e["quote"]["USD"]["percent_change_24h"],
          e["quote"]["USD"]["market_cap"] * 5.6);

      currencyList.add(currency);
    }
  }
}
