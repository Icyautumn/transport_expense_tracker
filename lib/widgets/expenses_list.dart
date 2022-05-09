import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transport_expense_tracker/all_expense.dart';
import 'package:transport_expense_tracker/expense.dart';

class ExpensesList extends StatefulWidget {
  @override
  State<ExpensesList> createState() => _ExpensesListState();
}



class _ExpensesListState extends State<ExpensesList> {
  void removeItem(int i, AllExpenses myExpenses) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('confirmation'),
            content: Text('Are you sure you want to delete? '),
            actions: [
              // if yes to delete
              TextButton(
                  onPressed: () {
                    setState(() {
                      myExpenses.removeExpense(i);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Yes')),
                  // if no to delete
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    AllExpenses expenseList = Provider.of<AllExpenses>(context);

    return ListView.separated(
      itemBuilder: (ctx, i) {
        return ListTile(
          leading: CircleAvatar(
            child: Text(expenseList.getMyExpense()[i].mode),
          ),
          title: Text(expenseList.getMyExpense()[i].purpose),
          subtitle: Text(expenseList.getMyExpense()[i].cost.toStringAsFixed(2)),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              removeItem(i, expenseList);
            },
          ),
        );
      },
      itemCount: expenseList.getMyExpense().length,
      separatorBuilder: (ctx, i) {
        return Divider(height: 3, color: Colors.blueGrey);
      },
    );
  }
}
