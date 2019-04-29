import 'package:flutter/material.dart';
import 'package:money/money.dart';
import 'package:decimal/decimal.dart';

import 'package:fforex_client/config/currency_data.dart';
import 'package:fforex_client/models/wallet.dart';
import 'package:fforex_client/blocs/wallect_bloc.dart';
import 'package:fforex_client/blocs/bloc_base.dart';
import 'package:fforex_client/tools/currency_exchanger.dart';
import 'package:fforex_client/components/currency_option.dart';

class ForexPanel extends StatelessWidget {
  final Wallet wallet;
  final WallectBloc bloc;

  ForexPanel(this.wallet, this.bloc);

  ForexPanel.initial(String name, String balanceValue, String currencyCode)
      : wallet = createWallect(name, balanceValue, currencyCode),
        bloc = WallectBloc(createWallect(name, balanceValue, currencyCode));

  static Wallet createWallect(
    String name,
    String balanceValue,
    String currencyCode,
  ) {
    Currency _currency = Currency.withCodeAndPrecision(
      currencyCode,
      CurrencyExchanger().getcurrencyFormat(currencyCode).fractionSize,
    );

    return Wallet(
      name: 'My Wallect',
      balance: Decimal.parse(balanceValue),
      currency: _currency,
    );
  }

  void add(String value) {
    bloc.additionSink.add(Decimal.parse(value));
  }

  @override
  Widget build(BuildContext context) {
    var keys = CurrencyData.list.keys.toList();
    return BlocProvider(
      bloc: bloc,
      child: Column(
        children: <Widget>[
          Card(
            child: Container(
              margin: EdgeInsets.all(32.0),
              padding: EdgeInsets.all(32.0),
              child: Column(
                children: <Widget>[
                  Text(wallet.name),
                  StreamBuilder<Money>(
                    stream: bloc.amountStream,
                    initialData: wallet.balance,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<Money> snapshot,
                    ) =>
                        Text(snapshot.data.encodedBy(DisplayCurrencyEncoder())),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return CurrencyOption(
                    Currency.withCodeAndPrecision(
                      keys[index],
                      CurrencyData.list[keys[index]]['fractionSize'],
                    ),
                    bloc);
              },
              itemCount: CurrencyData.list.keys.length,
            ),
          )
        ],
      ),
    );
  }
}
