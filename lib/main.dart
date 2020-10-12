import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cryptolisted',
      theme: ThemeData(
          primaryColor: Colors.purple,
          buttonTheme: ButtonThemeData(
              buttonColor: Colors.white, textTheme: ButtonTextTheme.accent)),
      home: MyHomePage(title: 'Cryptolisted'),
    );
  }
}

class InputValuePage extends StatefulWidget {
  InputValuePage({Key key, this.title, this.selectedCurrency})
      : super(key: key);

  final String title;
  final Currency selectedCurrency;

  @override
  _InputValuePageState createState() => _InputValuePageState();
}

class _InputValuePageState extends State<InputValuePage> {
  Currency selectedCurrency;
  double amount;

  @override
  initState() {
    super.initState();

    selectedCurrency = widget.selectedCurrency;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              children: [
                TextField(onChanged: (text) {
                  setState(() {
                    amount = double.parse(text);
                  });
                }),
                FlatButton(
                  onPressed: () {
                    print(amount);
                  },
                  child: Text('Confirmar'),
                )
              ],
            )));
  }
}

class AddTransactionPage extends StatefulWidget {
  AddTransactionPage({Key key, this.title, this.currencyList})
      : super(key: key);

  final String title;
  final List<Currency> currencyList;

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  List<Currency> currencyList;

  @override
  initState() {
    super.initState();

    currencyList = widget.currencyList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              children: [
                Center(
                  child: Text('Qual criptomoeda gostaria de adicionar?'),
                ),
                TextField(onChanged: (text) {
                  setState(() {
                    currencyList = widget.currencyList
                        .where((i) => i.name.toLowerCase().contains(text))
                        .toList();
                  });
                }),
                SortedList(currencyList, (currency) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InputValuePage(
                              title: currency.name,
                              selectedCurrency: currency)));
                })
              ],
            )));
  }
}

class PortfolioPage extends StatefulWidget {
  PortfolioPage({Key key, this.title, this.currencyList}) : super(key: key);

  final String title;
  final List<Currency> currencyList;

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  List<Currency> currencyList;

  @override
  initState() {
    super.initState();

    currencyList = widget.currencyList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              children: [
                Center(
                  child: Text(
                      'Clique no botão abaixo para adicionar seu primeiro ativo'),
                ),
              ],
            )),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddTransactionPage(
                          title: 'Adicionar transação',
                          currencyList: currencyList)));
            },
            child: Icon(Icons.add)));
  }
}

class SortedList extends StatelessWidget {
  String value = '';
  List<Currency> _currencyList = [];
  Function onCurrencySelect;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: _currencyList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  onTap: () {
                    onCurrencySelect(_currencyList[index]);
                  },
                  leading: Text.rich(TextSpan(children: <TextSpan>[
                    TextSpan(text: (index + 1).toString()),
                    TextSpan(text: ' '),
                    TextSpan(text: _currencyList[index].symbol)
                  ])),
                  title: Text(_currencyList[index].name),
                  subtitle: Text.rich(TextSpan(children: [
                    TextSpan(text: 'R\$'),
                    TextSpan(
                        text: _currencyList[index].price.toStringAsFixed(2))
                  ])),
                  trailing: Text.rich(TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: _currencyList[index]
                                .priceChange
                                .toStringAsFixed(2)),
                        TextSpan(text: '%')
                      ],
                      style: TextStyle(
                          color: _currencyList[index].priceChange >= 0
                              ? Colors.green
                              : Colors.red))));
            }));
  }

  SortedList(this._currencyList, this.onCurrencySelect);
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Currency> currencyList = [];

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
          e["quote"]["USD"]["market_cap"]);

      _currencyList.add(currency);
    }

    setState(() {
      currencyList = _currencyList;
    });

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
          child: Column(children: [
            ButtonRow(currencyList),
            FutureBuilder(
              future: _getCurrencies(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(child: Center(child: Text("Carregando...")));
                } else {
                  return Expanded(
                      child: ListView.builder(
                    itemCount: currencyList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          leading: Text.rich(TextSpan(children: <TextSpan>[
                            TextSpan(text: (index + 1).toString()),
                            TextSpan(text: ' '),
                            TextSpan(text: currencyList[index].symbol)
                          ])),
                          title: Text(currencyList[index].name),
                          subtitle: Text.rich(TextSpan(children: [
                            TextSpan(text: 'R\$'),
                            TextSpan(
                                text: currencyList[index]
                                    .price
                                    .toStringAsFixed(2))
                          ])),
                          trailing: Text.rich(TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: currencyList[index]
                                        .priceChange
                                        .toStringAsFixed(2)),
                                TextSpan(text: '%')
                              ],
                              style: TextStyle(
                                  color: currencyList[index].priceChange >= 0
                                      ? Colors.green
                                      : Colors.red))));
                    },
                  ));
                }
              },
            ),
          ]),
        ));
  }
}

class ButtonRow extends StatelessWidget {
  final List<Currency> _currencyList;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {},
              child: Container(child: Text('Sobre')),
            ),
            SizedBox(
              width: 40,
            ),
            RaisedButton(
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PortfolioPage(
                            title: 'Portfolio', currencyList: _currencyList)))
              },
              child: Container(child: Text('Portfolio')),
            ),
          ],
        ));
  }

  ButtonRow(this._currencyList);
}

class Currency {
  final String name;
  final String symbol;
  final double price;
  final double priceChange;
  final double marketCap;

  Currency(
      this.name, this.symbol, this.price, this.priceChange, this.marketCap);
}
