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
            buttonColor: Colors.white,
            textTheme: ButtonTextTheme.primary
            )),
      home: MyHomePage(title: 'Cryptolisted'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Currency>> _getCurrencies() async {
    var data = await http.get(
        'https://sandbox-api.coinmarketcap.com/v1/cryptocurrency/listings/latest',
        headers: {'X-CMC_PRO_API_KEY': 'b54bcf4d-1bca-4e8e-9a24-22ff2c3d462c'});
    var jsonData = json.decode(data.body)["data"];

    List<Currency> currencyList = [];

    for (var e in jsonData) {
      Currency currency = Currency(
          e["name"],
          e["symbol"],
          e["quote"]["USD"]["price"] * 5.6,
          e["quote"]["USD"]["percent_change_24h"],
          e["quote"]["USD"]["market_cap"]);

      currencyList.add(currency);
    }

    return currencyList;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(children: [
        buttonRow,
        FutureBuilder(
          future: _getCurrencies(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(child: Center(child: Text("Carregando...")));
            } else {
              return Expanded(
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
                            text: snapshot.data[index].price.toStringAsFixed(2))
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
              ));
            }
          },
        ),
      ]),
    );
  }

  Widget buttonRow = Container(
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
        onPressed: () {},
        child: Container(child: Text('Portfolio')),
      ),
    ],
  ));
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
