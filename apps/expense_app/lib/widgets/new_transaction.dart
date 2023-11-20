import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  late final Function addTrx;

  NewTransaction(this.addTrx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  //Define the variable for handling changes to a TextField....
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  //2. add method submitData
  void submitData() {
    //local variables
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    //to verify the data entry
    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      print('#Debug2 - Passing 2..');
      return; //will proceed to another code
    }

    widget.addTrx(
      enteredTitle,
      enteredAmount,
    );

    //adding navigator to automatically close the Modal Bottom Sheet (dialog box)
    // after user key-in the new record
    Navigator.of(context).pop();

    print('#Debug1 - Passing 1..');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
              onSubmitted: (_) => submitData(),
              //onChanged: (val) => { titleInput = val},   // Note: 1st approach
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType: TextInputType
                  .number, //1. add the keyboardType, to capture data type as a number
              onSubmitted: (_) => submitData(),
              //onChanged: (val) => { amountInput = val},
            ),
            Container(
              height: 70,
              child: Row(
                children: <Widget>[
                  Text('No Date Chosen'),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                print(titleController);
                print(amountController);
                (_) => submitData(); //adding function to Button

                /*addTrx(
                  titleController.text,
                  double.parse(amountController.text),
                );*/
              },
              child: Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
