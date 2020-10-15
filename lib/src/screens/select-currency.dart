import 'package:flutter/material.dart';

import './input-value.dart';
import '../models/currency.dart';
import '../widgets/sorted-list.dart';

class SelectCurrencyPage extends StatefulWidget {
  SelectCurrencyPage({Key key, this.title, this.currencyList})
      : super(key: key);

  final String title;
  final List<Currency> currencyList;

  @override
  _SelectCurrencyPageState createState() => _SelectCurrencyPageState();
}

class _SelectCurrencyPageState extends State<SelectCurrencyPage> {
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
