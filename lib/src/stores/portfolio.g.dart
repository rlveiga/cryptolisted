// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PortfolioStore on PortfolioBase, Store {
  final _$portfolioAtom = Atom(name: 'PortfolioBase.portfolio');

  @override
  List<PortfolioAsset> get portfolio {
    _$portfolioAtom.reportRead();
    return super.portfolio;
  }

  @override
  set portfolio(List<PortfolioAsset> value) {
    _$portfolioAtom.reportWrite(value, super.portfolio, () {
      super.portfolio = value;
    });
  }

  @override
  String toString() {
    return '''
portfolio: ${portfolio}
    ''';
  }
}
