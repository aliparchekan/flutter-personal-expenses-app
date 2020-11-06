import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './widgets/chart.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transactions.dart';

import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        accentColor: Colors.teal,
        errorColor: Colors.red[600],
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'new shoes',
    //   amount: 12.11,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Shop',
    //   amount: 18.99,
    //   date: DateTime.now(),
    // ),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((transaction) {
      return transaction.date.isAfter(
        DateTime.now().subtract(
          Duration(
            days: 7,
          ),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: date,
    );
    setState(() {
      _transactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData MediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'show chart',
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch.adaptive(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          )
        ],
      ),
      _showChart
          ? Container(
              height: (MediaQuery.size.height -
                      appBar.preferredSize.height -
                      MediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData MediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
        height: (MediaQuery.size.height -
                appBar.preferredSize.height -
                MediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    _startAddNewTransaction(context);
                  },
                  child: Icon(CupertinoIcons.add),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Personal Expenses',
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _startAddNewTransaction(context);
                  }),
            ],
          );
    final txListWidget = Container(
      child: TransactionList(_transactions, _deleteTransaction),
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
    );
    final body = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              ..._buildLandscapeContent(
                MediaQuery.of(context),
                appBar,
                txListWidget,
              ),
            if (!isLandscape)
              ..._buildPortraitContent(
                MediaQuery.of(context),
                appBar,
                txListWidget,
              )
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: body,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: body,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      _startAddNewTransaction(context);
                    },
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
