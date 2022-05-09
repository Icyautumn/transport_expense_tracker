import 'package:flutter/cupertino.dart';

import 'expense.dart';

class AllExpenses with ChangeNotifier{
  List <Expense> myExpense = [];
  
// returns my Expenses variable to the caller
  List<Expense> getMyExpense() {
    return myExpense;
  }

// insert the new expense object at the front of the list
  void addExpense(purpose, mode, cost, travelDate) {
    myExpense.insert(0, Expense(purpose: purpose, mode: mode, cost: cost, TravelDate: travelDate));
    notifyListeners();
  }

// removes the expense object at the front of the list
  void removeExpense(i) {
    myExpense.removeAt(i);
    notifyListeners();
  }

// loop through myExpenes, compute and return total sum
  double getTotalSpend() {
    double sum = 0;

    myExpense.forEach((element) {
      sum += element.cost;
    });

    return sum;
  }
}