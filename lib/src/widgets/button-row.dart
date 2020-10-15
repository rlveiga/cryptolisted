import 'package:flutter/material.dart';

import '../models/currency.dart';
import '../screens/portfolio.dart';

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
