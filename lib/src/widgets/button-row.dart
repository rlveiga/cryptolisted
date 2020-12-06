import 'package:flutter/material.dart';

import '../models/currency.dart';
import '../screens/portfolio.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                            title: AppLocalizations.of(context).portfolioButton, currencyList: _currencyList)))
              },
              child: Container(child: Text(AppLocalizations.of(context).portfolioButton)),
            ),
          ],
        ));
  }

  ButtonRow(this._currencyList);
}
