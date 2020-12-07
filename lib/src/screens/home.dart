import 'package:Cryptolisted/src/stores/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../models/currency.dart';
import '../widgets/button-row.dart';
import '../widgets/sorted-list.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final currencyStore = Provider.of<CurrencyStore>(context);

    _getCurrencies() async {
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

      currencyStore.addToList(currency);
    }

    return true;
  }

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
                return Container(
                    child: Center(
                        child: Text(AppLocalizations.of(context).loading)));
              } else {
                return Column(children: [
                  ButtonRow(),
                  Expanded(child: Observer(builder: (_) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: currencyStore.currencyList.length,
                        itemBuilder: (_, int index) {
                          return ListTile(
                              leading: Text.rich(TextSpan(children: <TextSpan>[
                                TextSpan(text: (index + 1).toString()),
                                TextSpan(text: ' '),
                                TextSpan(
                                    text: currencyStore
                                        .currencyList[index].symbol)
                              ])),
                              title:
                                  Text(currencyStore.currencyList[index].name),
                              subtitle: Text.rich(TextSpan(children: [
                                TextSpan(text: 'R\$'),
                                TextSpan(
                                    text: currencyStore
                                        .currencyList[index].price
                                        .toStringAsFixed(2))
                              ])),
                              trailing: Text.rich(TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: currencyStore
                                            .currencyList[index].priceChange
                                            .toStringAsFixed(2)),
                                    TextSpan(text: '%')
                                  ],
                                  style: TextStyle(
                                      color: currencyStore.currencyList[index]
                                                  .priceChange >=
                                              0
                                          ? Colors.green
                                          : Colors.red))));
                        });
                  }))
                ]);
              }
            },
          ),
        ));
  }
}
