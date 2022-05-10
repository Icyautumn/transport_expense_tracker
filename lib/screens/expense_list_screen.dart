import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transport_expense_tracker/expense.dart';
import 'package:transport_expense_tracker/screens/add_expense_screen.dart';
import 'package:transport_expense_tracker/services/firestore_service.dart';
import 'package:transport_expense_tracker/widgets/app_drawer.dart';
import 'package:transport_expense_tracker/widgets/expenses_list.dart';

class ExpenseListScreen extends StatelessWidget {
  static String routeName = '/expense-list';

  @override
  Widget build(BuildContext context) {
    FireStoreService fsService = FireStoreService();

    return StreamBuilder<List<Expense>>(
        stream: fsService.getExpenses(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : Scaffold(
                  appBar: AppBar(
                    title: Text('My Expense'),
                  ),
                  body: Container(
                      alignment: Alignment.center,
                      child: snapshot.data == null
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Image.asset('images/picture.png', width: 300),
                                Text('No expenses yet, add a new one today!',
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                              ],
                            )
                          : ExpensesList()),
                  drawer: AppDrawer(),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AddExpenseScreen.routeName);
                    },
                    child: Icon(Icons.add),
                  ),
                );
        });
  }
}
