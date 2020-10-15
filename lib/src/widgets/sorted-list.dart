import 'package:flutter/material.dart';

import '../models/currency.dart';

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
