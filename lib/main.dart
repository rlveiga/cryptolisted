import 'package:Cryptolisted/src/stores/currency.dart';
import 'package:flutter/material.dart';

import 'package:Cryptolisted/src/screens/home.dart';
import 'package:Cryptolisted/src/theme/style.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CurrencyStore>(create: (_) => CurrencyStore()),
      ],
      child: MaterialApp(
          title: 'Cryptolisted',
          theme: appTheme(),
          home: HomePage(title: 'Cryptolisted'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''),
            const Locale('pt', 'BR')
          ]),
    );
  }
}
