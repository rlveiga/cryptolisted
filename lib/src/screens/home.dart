import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/currency.dart';
import '../widgets/button-row.dart';
import '../widgets/sorted-list.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Currency>> _getCurrencies() async {
    var data = await http.get(
        'https://sandbox-api.coinmarketcap.com/v1/cryptocurrency/listings/latest',
        headers: {'X-CMC_PRO_API_KEY': 'b54bcf4d-1bca-4e8e-9a24-22ff2c3d462c'});
    var jsonData = json.decode(data.body)["data"];

    List<Currency> _currencyList = [];

    for (var e in jsonData) {
      Currency currency = Currency(
          e["name"],
          e["symbol"],
          e["quote"]["USD"]["price"] * 5.6,
          e["quote"]["USD"]["percent_change_24h"],
          e["quote"]["USD"]["market_cap"] * 5.6);

      _currencyList.add(currency);
    }

    return _currencyList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 12),
          child: FutureBuilder(
            future: _getCurrencies(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(child: Center(child: Text(AppLocalizations.of(context).loading)));
              } else {
                return Column(children: [
                  ButtonRow(snapshot.data),
                  SortedList(snapshot.data, (currency) {})
                ]);
              }
            },
          ),
        ));
  }
}
