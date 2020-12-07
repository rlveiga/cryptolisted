import 'package:Cryptolisted/src/stores/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import './input-value.dart';
import '../models/currency.dart';
import '../widgets/sorted-list.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectCurrencyPage extends StatefulWidget {
  SelectCurrencyPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SelectCurrencyPageState createState() => _SelectCurrencyPageState();
}

class _SelectCurrencyPageState extends State<SelectCurrencyPage> {
  String input;

  @override
  initState() {
    super.initState();

    input = '';
  }

  @override
  Widget build(BuildContext context) {
    final currencyStore = Provider.of<CurrencyStore>(context);

    List<Currency> getSortedList() {
      return currencyStore.currencyList
          .where((i) => i.name.toLowerCase().contains(input.toLowerCase()))
          .toList();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              children: [
                Center(
                  child:
                      Text(AppLocalizations.of(context).portfolioAddQuestion),
                ),
                TextField(onChanged: (text) {
                  setState(() {
                    input = text;
                  });
                }),
                Expanded(child: Observer(builder: (_) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: getSortedList().length,
                      itemBuilder: (_, int index) {
                        return ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => InputValuePage(
                                          title: getSortedList()[index].name,
                                          selectedCurrency:
                                              getSortedList()[index])));
                            },
                            leading: Text.rich(TextSpan(children: <TextSpan>[
                              TextSpan(text: (index + 1).toString()),
                              TextSpan(text: ' '),
                              TextSpan(text: getSortedList()[index].symbol)
                            ])),
                            title: Text(getSortedList()[index].name),
                            subtitle: Text.rich(TextSpan(children: [
                              TextSpan(text: 'R\$'),
                              TextSpan(
                                  text: getSortedList()[index]
                                      .price
                                      .toStringAsFixed(2))
                            ])),
                            trailing: Text.rich(TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: getSortedList()[index]
                                          .priceChange
                                          .toStringAsFixed(2)),
                                  TextSpan(text: '%')
                                ],
                                style: TextStyle(
                                    color:
                                        getSortedList()[index].priceChange >= 0
                                            ? Colors.green
                                            : Colors.red))));
                      });
                }))
              ],
            )));
  }
}
