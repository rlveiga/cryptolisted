import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/currency.dart';
import '../widgets/button-row.dart';

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
                return Container(child: Center(child: Text("Carregando...")));
              } else {
                return Column(children: [
                  ButtonRow(snapshot.data),
                  Expanded(
                      child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          leading: Text.rich(TextSpan(children: <TextSpan>[
                            TextSpan(text: (index + 1).toString()),
                            TextSpan(text: ' '),
                            TextSpan(text: snapshot.data[index].symbol)
                          ])),
                          title: Text(snapshot.data[index].name),
                          subtitle: Text.rich(TextSpan(children: [
                            TextSpan(text: 'R\$'),
                            TextSpan(
                                text: snapshot.data[index].price
                                    .toStringAsFixed(2))
                          ])),
                          trailing: Text.rich(TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: snapshot.data[index].priceChange
                                        .toStringAsFixed(2)),
                                TextSpan(text: '%')
                              ],
                              style: TextStyle(
                                  color: snapshot.data[index].priceChange >= 0
                                      ? Colors.green
                                      : Colors.red))));
                    },
                  ))
                ]);
              }
            },
          ),
        ));
  }
}
