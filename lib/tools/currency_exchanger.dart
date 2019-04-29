import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:money/money.dart';
import 'package:decimal/decimal.dart';
import 'package:http/http.dart';

import 'package:fforex_client/config/api.dart';
import 'package:fforex_client/config/currency_data.dart';
import 'package:fforex_client/models/currency_format.dart';
import 'package:fforex_client/models/wallet.dart';
import 'package:fforex_client/tools/http_client.dart';

class CurrencyExchanger {
  static final CurrencyExchanger _instance = CurrencyExchanger._();

  CurrencyExchanger._();

  factory CurrencyExchanger() {
    return _instance;
  }

  String display(MoneyData moneyData) {
    Currency currency = moneyData.currency;
    CurrencyFormat currencyFormat =
        CurrencyFormat.fromJson(CurrencyData.list[currency.code]);

    return currencyFormat.template
        .replaceFirst(
          RegExp('${CurrencyData.REGEXMONEY}'),
          _getDecimal(moneyData).toString(),
        )
        .replaceFirst(
          RegExp('${CurrencyData.REGEXSYMBAL}'),
          currencyFormat.grapheme,
        );
  }

  Future<Wallet> exchange(Wallet source, String targetCode) async {
    Wallet _target = Wallet(
      name: source.name,
      balance: source.originBalance,
      currency: source.originCurrency,
    );

    Currency targetCurrency = getCurrency(targetCode);

    Response response = await HttpClient().execGET(
        '${API.root}${API.forex}?c=${source.originCurrency.code}&a=${source.originBalance.toString()}');

    Map<String, dynamic> jsonData = jsonDecode(response.body);

    _target.rawBalance = Decimal.parse('${jsonData[targetCode]}');

    _target.balance = Money.withSubunits(
        decimalToBigInt(
          _target.rawBalance,
          getcurrencyFormat(targetCode),
        ),
        targetCurrency);

    _target.currency = targetCurrency;
    return _target;
  }

  Decimal bigIntToDecimal(String amount, int fractionSize) {
    return Decimal.parse(amount) / _powerNumber(fractionSize);
  }

  BigInt decimalToBigInt(Decimal sourece, CurrencyFormat currencyFormat) {
    Decimal raw = sourece * _powerNumber(currencyFormat.fractionSize);
    return BigInt.from(raw.toInt());
  }

  Currency getCurrency(String code) {
    CurrencyFormat currencyFormat = getcurrencyFormat(code);
    return Currency.withCodeAndPrecision(
        currencyFormat.nameISO, currencyFormat.fractionSize);
  }

  CurrencyFormat getcurrencyFormat(String code) {
    return CurrencyFormat.fromJson(CurrencyData.list[code]);
  }

  Decimal _powerNumber(int fractionSize) {
    return Decimal.parse(pow(
      10,
      fractionSize,
    ).toString());
  }

  Decimal _getDecimal(MoneyData moneyData) {
    return bigIntToDecimal(
      moneyData.subunits.toString(),
      moneyData.currency.precision,
    );
  }
}

class DisplayCurrencyEncoder implements MoneyEncoder<String> {
  @override
  String encode(MoneyData moneyData) {
    return CurrencyExchanger().display(moneyData);
  }
}
