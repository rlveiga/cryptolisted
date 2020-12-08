import 'dart:convert';

import 'package:Cryptolisted/src/screens/select-currency.dart';
import 'package:Cryptolisted/src/stores/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/currency.dart';
import '../models/portfolio-asset.dart';

final currencyStore = CurrencyStore();
class PortfolioPage extends StatefulWidget {
  PortfolioPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  String input;

  @override
  initState() {
    super.initState();

    input = '';
  }

  @override
  Widget build(BuildContext context) {
    final currencyStore = Provider.of<CurrencyStore>(context);

    Future<List<PortfolioAsset>> _getPortfolio() async {
    var data = await http.get('https://cryptolisted.herokuapp.com/portfolio');

    var jsonData = json.decode(data.body);

    List<PortfolioAsset> _portfolioList = [];

    for (var e in jsonData) {
      var currency =
          currencyStore.currencyList.firstWhere((item) => item.symbol == e['symbol']);

      var newAsset = PortfolioAsset(currency, e['amount'].toDouble());
      _portfolioList.add(newAsset);
    }

    return _portfolioList;
  }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            padding: const EdgeInsets.only(top: 25),
            child: Observer(builder: (_) {
              return FutureBuilder(
                  future: _getPortfolio(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                          child: Center(
                              child:
                                  Text(AppLocalizations.of(context).loading)));
                    } else {
                      if (snapshot.data == []) {
                        return (Center(
                          child:
                              Text(AppLocalizations.of(context).addToPortfolio),
                        ));
                      } else {
                        return Column(
                          children: [
                            Expanded(
                                child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                    leading: Text(
                                        snapshot.data[index].amount.toString()),
                                    title: Text(
                                        snapshot.data[index].currency.symbol),
                                    subtitle: Text.rich(TextSpan(children: [
                                      TextSpan(text: 'R\$'),
                                      TextSpan(
                                          text: (snapshot.data[index].currency
                                                      .price *
                                                  snapshot.data[index].amount)
                                              .toStringAsFixed(2))
                                    ])),
                                    trailing: Text.rich(TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: snapshot.data[index]
                                                  .currency.priceChange
                                                  .toStringAsFixed(2)),
                                          TextSpan(text: '%')
                                        ],
                                        style: TextStyle(
                                            color: snapshot.data[index].currency
                                                        .priceChange >=
                                                    0
                                                ? Colors.green
                                                : Colors.red))));
                              },
                            ))
                          ],
                        );
                      }
                    }
                  });
            })),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectCurrencyPage(
                          title:
                              AppLocalizations.of(context).addCurrencyTitle)));
            },
            child: Icon(Icons.add)));
  }
}
