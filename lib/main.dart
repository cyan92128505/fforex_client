import 'package:flutter/material.dart';
import 'package:fforex_client/components/forex_panel.dart';

ForexPanel forexPanel = ForexPanel.initial(
  'My Wallect',
  '100.00',
  'TWD',
);

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello World',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: Scaffold(
        body: forexPanel,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => forexPanel.add('1'),
        ),
      ),
    );
  }
}
