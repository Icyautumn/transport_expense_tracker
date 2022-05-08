import 'package:flutter/material.dart';
import 'package:transport_expense_tracker/expense.dart';

class ExpensesList extends StatelessWidget {
  List<Expense> myExpenses;
  Function removeItem;

  ExpensesList(this.myExpenses, this.removeItem);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (ctx, i) {
        return ListTile(
          leading: CircleAvatar(
            child: Text(myExpenses[i].mode),
          ),
          title: Text(myExpenses[i].purpose),
          subtitle: Text(myExpenses[i].cost.toStringAsFixed(2)),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              removeItem(i);
            },
          ),
        );
      },
      itemCount: myExpenses.length,
      separatorBuilder: (ctx, i) {
        return Divider(height: 3, color: Colors.blueGrey);
      },
    );
  }
}
