import 'package:Cryptolisted/src/models/portfolio-asset.dart';
import 'package:mobx/mobx.dart';

part 'portfolio.g.dart';

class PortfolioStore = PortfolioBase with _$PortfolioStore;

abstract class PortfolioBase with Store {
  @observable
  List<PortfolioAsset> portfolio = [];
}