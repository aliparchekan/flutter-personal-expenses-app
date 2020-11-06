import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function handleNewTransaction;

  NewTransaction(this.handleNewTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _chosenDate;

  void _handleSubmission() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _chosenDate == null) {
      return;
    }

    widget.handleNewTransaction(
      enteredTitle,
      enteredAmount,
      _chosenDate,
    );
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _chosenDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) => _handleSubmission(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _handleSubmission(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_chosenDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Date: ${DateFormat.yMEd().format(_chosenDate)}'),
                    ),
                    Platform.isIOS
                        ? CupertinoButton(
                            child: Text(
                              'Choose Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: _presentDatePicker,
                          )
                        : FlatButton(
                            onPressed: _presentDatePicker,
                            child: Text(
                              'Choose Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            textColor: Theme.of(context).primaryColor,
                          )
                  ],
                ),
              ),
              Platform.isIOS
                  ? CupertinoButton(
                      child: Text(
                        'Add Transaction',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.button.color),
                      ),
                      onPressed: _handleSubmission,
                      color: Theme.of(context).accentColor,
                    )
                  : RaisedButton(
                      onPressed: _handleSubmission,
                      color: Theme.of(context).accentColor,
                      textColor: Theme.of(context).textTheme.button.color,
                      child: Text('Add Transaction'),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
