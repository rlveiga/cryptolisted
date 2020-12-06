// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CurrencyStore on CurrencyBase, Store {
  final _$currencyListAtom = Atom(name: 'CurrencyBase.currencyList');

  @override
  ObservableList<Currency> get currencyList {
    _$currencyListAtom.reportRead();
    return super.currencyList;
  }

  @override
  set currencyList(ObservableList<Currency> value) {
    _$currencyListAtom.reportWrite(value, super.currencyList, () {
      super.currencyList = value;
    });
  }

  final _$getCurrencyListAsyncAction =
      AsyncAction('CurrencyBase.getCurrencyList');

  @override
  Future getCurrencyList() {
    return _$getCurrencyListAsyncAction.run(() => super.getCurrencyList());
  }

  @override
  String toString() {
    return '''
currencyList: ${currencyList}
    ''';
  }
}
