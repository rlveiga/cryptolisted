import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/currency.dart';

import 'package:Cryptolisted/notification-plugin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  double value;
  double amount;

  _addToPortfolio() async {
    await http.post('http://10.0.2.2:3000/portfolio',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'symbol': selectedCurrency.symbol,
          'amount': amount
        }));

    notificationPlugin.showNotification('${selectedCurrency.name} adicionado ao Portfolio!', null);
  }

  @override
  initState() {
    super.initState();

    selectedCurrency = widget.selectedCurrency;
    value = 0;
    amount = 0;
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
                    var inputValue;

                    if (text == '') {
                      inputValue = 0.0;
                    } else {
                      inputValue = double.parse(text);
                    }

                    amount = inputValue;
                    value = (inputValue * selectedCurrency.price);
                  });
                }),
                Text.rich(TextSpan(children: <TextSpan>[
                  TextSpan(text: 'R\$'),
                  TextSpan(text: value.toStringAsFixed(2))
                ])),
                FlatButton(
                  onPressed: () {
                    _addToPortfolio();

                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context).loading),
                )
              ],
            )));
  }
}
