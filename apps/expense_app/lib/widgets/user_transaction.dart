import 'package:flutter/material.dart';
import './new_transaction.dart';
import './transaction_list.dart';
import '../models/transaction.dart';

class UserTransactions extends StatefulWidget {
  const UserTransactions({Key? key}) : super(key: key);

  @override
  State<UserTransactions> createState() => _UserTransactionsState();
}

class _UserTransactionsState extends State<UserTransactions> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'Nike Shoes',
      amount: 359.00,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      amount: 55.50,
      date: DateTime.now(),
    ),
  ];

  //To add a method known as _addNewTransaction() and setState() in order
  //to preserve the new value of data when rendering the user_transaction.
  void _addNewTransaction(String trxTitle, double trxAmount) {
    final newTrx = Transaction(
        id: DateTime.now().toString(),
        title: trxTitle,
        amount: trxAmount,
        date: DateTime.now());

    setState(() {
      _userTransactions.add(newTrx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NewTransaction(_addNewTransaction),
        TransactionList(_userTransactions),
      ],
    );
  }
}
