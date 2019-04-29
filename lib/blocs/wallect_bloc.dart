import 'dart:async';
import 'package:money/money.dart';
import 'package:decimal/decimal.dart';

import 'package:fforex_client/tools/currency_exchanger.dart';
import 'package:fforex_client/blocs/bloc_base.dart';
import 'package:fforex_client/models/wallet.dart';

class WallectBloc implements BlocBase {
  final Wallet wallet;

  StreamController<Money> _amountController = StreamController();
  StreamSink<Money> get amountSink => _amountController.sink;
  Stream<Money> get amountStream => _amountController.stream;

  StreamController<Decimal> _additionController = StreamController();
  StreamSink<Decimal> get additionSink => _additionController.sink;
  Stream<Decimal> get additionStream => _additionController.stream;

  StreamController<Currency> _currencyController = StreamController();
  StreamSink<Currency> get currencySink => _currencyController.sink;
  Stream<Currency> get currencyStream => _currencyController.stream;

  StreamController<Currency> _exchangeCurrencyController = StreamController();
  StreamSink<Currency> get exchangeCurrencySink =>
      _exchangeCurrencyController.sink;
  Stream<Currency> get exchangeCurrencyStream =>
      _exchangeCurrencyController.stream;

  WallectBloc(this.wallet) {
    additionStream.listen(_additionLogic);
    exchangeCurrencyStream.listen(_exchangeCurrencyLogic);
  }

  void _additionLogic(Decimal money) {
    try {
      wallet.originBalance = wallet.originBalance + money;
      _exchangeCurrencyLogic(wallet.currency);
    } catch (e) {
      print(e);
    }
  }

  void _exchangeCurrencyLogic(Currency currency) async {
    try {
      Wallet exchangedWallect =
          await CurrencyExchanger().exchange(wallet, currency.code);

      wallet.rawBalance = exchangedWallect.rawBalance;
      wallet.balance = exchangedWallect.balance;
      wallet.currency = exchangedWallect.currency;

      amountSink.add(wallet.balance);
    } catch (e) {
      print(e);
    }
  }

  void dispose() {
    _amountController.close();
    _additionController.close();
    _currencyController.close();
    _exchangeCurrencyController.close();
  }
}
