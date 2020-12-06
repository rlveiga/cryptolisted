import 'package:Cryptolisted/src/stores/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/currency.dart';
import '../widgets/button-row.dart';
import '../widgets/sorted-list.dart';

final currencyStore = CurrencyStore();

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _getCurrencies() async {
    await currencyStore.getCurrencyList();

    return currencyStore.currencyList;
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
                return Container(child: Center(child: Text(AppLocalizations.of(context).loading)));
              } else {
                return Column(children: [
                  ButtonRow(),
                  SortedList(snapshot.data, (currency) {})
                ]);
              }
            },
          ),
        ));
  }
}
