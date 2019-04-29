import 'package:flutter/material.dart';
import 'package:money/money.dart';
import 'package:fforex_client/blocs/wallect_bloc.dart';

class CurrencyOption extends StatelessWidget {
  final Currency currency;
  final WallectBloc bloc;
  CurrencyOption(this.currency, this.bloc);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          child: ListTile(
            title: Text(this.currency.code),
          ),
          onTap: () => bloc.exchangeCurrencySink.add(this.currency),
        ),
        Divider(
          height: 2.0,
        ),
      ],
    );
  }
}
