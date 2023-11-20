import 'package:flutter/material.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Planner',
      debugShowCheckedModeBanner: false,
      //theme: ThemeData(
      //  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink)
      //    .copyWith(secondary: Colors.purple,)),
      theme: ThemeData(
        primarySwatch: Colors.pink,
        splashColor: Colors.purple,
        fontFamily: 'OpenSans',
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontFamily: 'QuickSand',
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          bodyText1: TextStyle(
            fontFamily: 'OpenSansSerif',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          bodyText2: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        )),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // Change to Stateful widget
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Move existing records in Transaction in here...
  final List<Transaction> _userTransactions = [
    /*Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      amount: 16.53,
      date: DateTime.now(),
    ), */
  ];

  List<Transaction> get _recentTransaction {
    return _userTransactions.where((trx) {
      return trx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  //add _addNewTransaction to cater for new record when user click
  // either at AppBar button or Floating Action Button
  void _addNewTransaction(String txTitle, double txAmount) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: DateTime.now(),
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx); // To retain the current records..
    });
  }

  //This is the method/function to render the Modal Bottom Sheet...
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child:
              NewTransaction(_addNewTransaction), // Call new_transaction.dart
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Planner'),
        backgroundColor: Colors.pink,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                _startAddNewTransaction(context), //Assign  Modal Bottom Sheet
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            /* Container(
              width: double.infinity,
              child: Card(
                color: Colors.pink,
                child: Text(
                  'CHART!',
                  style: TextStyle(color: Colors.white),
                ),
                elevation: 5,
              ),
            ),
            */
            //UserTransactions(), // Remove since this widget no longer used..
            //1. replace current Container widget with Chart widget
            Chart(_recentTransaction),
            TransactionList(_userTransactions), // To dislay the records..
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTransaction(context), // Modal Bottom Sheet
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
