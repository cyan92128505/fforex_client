import 'package:money/money.dart';
import 'package:decimal/decimal.dart';

import 'package:fforex_client/tools/currency_exchanger.dart';

class Wallet {
  String name;
  Money balance;
  Currency currency;
  Decimal rawBalance;

  Currency originCurrency;
  Decimal originBalance;

  Wallet({String name, Decimal balance, Currency currency}) {
    this.name = name;
    this.originBalance = balance;
    this.originCurrency = currency;

    this.rawBalance = balance;
    this.balance = Money.withSubunits(
        CurrencyExchanger().decimalToBigInt(
            balance, CurrencyExchanger().getcurrencyFormat(currency.code)),
        currency);
    this.currency = currency;
  }
}
