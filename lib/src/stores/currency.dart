import 'package:Cryptolisted/src/models/currency.dart';
import 'package:mobx/mobx.dart';

part 'currency.g.dart';

class CurrencyStore = CurrencyBase with _$CurrencyStore;

abstract class CurrencyBase with Store {
  ObservableList currencyList = ObservableList<Currency>();

  @action
  addToList(currency) {
    currencyList.add(currency);
  }
}
