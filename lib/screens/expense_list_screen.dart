import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transport_expense_tracker/all_expense.dart';
import 'package:transport_expense_tracker/screens/add_expense_screen.dart';
import 'package:transport_expense_tracker/widgets/app_drawer.dart';
import 'package:transport_expense_tracker/widgets/expenses_list.dart';

class ExpenseListScreen extends StatelessWidget {

  static String routeName = '/expense-list';

  @override
  Widget build(BuildContext context) {
    AllExpenses expenseList = Provider.of<AllExpenses>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Expense'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: expenseList.getMyExpense().length > 0 ? ExpensesList() : 
        Column(
          children: [
            SizedBox(height: 20,),
            Image.asset('images/picture.png', width: 300),
            Text('No expenses yet, add a new one today!', 
            style: Theme.of(context).textTheme.subtitle1),
          ],
        ),
      ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddExpenseScreen.routeName);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}