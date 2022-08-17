// ignore_for_file: prefer_const_constructors

import 'package:expense_manager/widgets/chart.dart';
import 'package:expense_manager/widgets/list_transactions.dart';
import 'package:expense_manager/widgets/newTransaction.dart';

// import '../widgets/user_transactoin.dart';
import 'package:flutter/material.dart';
import './models/transaction.dart';

main() => runApp(
      MaterialApp(
        title: 'Expense Manager',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.amber,
            fontFamily: 'QuickSand',
            // errorColor: Colors.redAccent,
            textTheme: ThemeData.light().textTheme.copyWith(
                  titleMedium: TextStyle(
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  // button: TextStyle(color: Colors.white),
                ),
            appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
                fontFamily: 'QuickSand',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              // textTheme: ThemeData.light().textTheme.copyWith(
              //       titleMedium: TextStyle(
              //         fontFamily: 'Open Sans',
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
            )),
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Transaction> transaction = [
    Transaction(
      id: 't1',
      date: DateTime.now(),
      amount: 12.22,
      title: 'Chocolates',
    ),
    Transaction(
      id: 't2',
      date: DateTime.now(),
      amount: 50.22,
      title: 'Books',
    ),
  ];

  _startNewTransaction(BuildContext ctx) {
    // print("called");
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return AddTransaction(_add_transaction);
        });
  }

  _add_transaction(double amount, String title, DateTime d) {
    setState(() {
      transaction.add(
        Transaction(
          id: DateTime.now().toString(),
          date: d,
          amount: amount,
          title: title,
        ),
      );
    });
  }

  List<Transaction> get recent {
    return transaction.where((element) {
      return element.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  _deleteExpense(String Id) {
    setState(() {
      transaction.removeWhere((element) => element.id == Id);
    });
  }

  _showSwitch(AppBar appbar) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart'),
          Switch(
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              })
        ],
      ),
      _showChart
          ? Container(
              height: (MediaQuery.of(context).size.height -
                      appbar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  .7,
              width: double.infinity,
              child: Chart(recent),
            )
          : Container(
              height: (MediaQuery.of(context).size.height -
                      appbar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.7,
              child: TransactionList(transaction, _deleteExpense),
            )
    ];
  }

  _showchart(AppBar appbar, Widget Ltx) {
    return [
      Container(
        height: (MediaQuery.of(context).size.height -
                appbar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            .3,
        width: double.infinity,
        child: Chart(recent),
      ),
      Ltx
    ];
  }

  var _showChart = false;
  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appbar =
        AppBar(title: Text('ExpenseManager'), actions: [
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () => _startNewTransaction(context),
      ),
    ]);
    final Ltx = Container(
      height: (MediaQuery.of(context).size.height -
              appbar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
      child: TransactionList(transaction, _deleteExpense),
    );
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: appbar,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startNewTransaction(context),
      ),
      body: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.,
          children: [
            if (isLandscape) ..._showSwitch(appbar),
            if (!isLandscape) ..._showchart(appbar, Ltx),
          ],
        ),
      ),
    );

    // );
  }
}
