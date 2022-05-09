import 'package:flutter/cupertino.dart';

import 'expense.dart';

class AllExpenses with ChangeNotifier{
  List <Expense> myExpense = [];

  List<Expense> getMyExpense() {
    return myExpense;
  }

  void addExpense(purpose, mode, cost, travelDate) {
    myExpense.insert(0, Expense(purpose: purpose, mode: mode, cost: cost, TravelDate: travelDate));
    notifyListeners();
  }

  void removeExpense(i) {
    myExpense.removeAt(i);
    notifyListeners();
  }

  double getTotalSpend() {
    double sum = 0;

    myExpense.forEach((element) {
      sum += element.cost;
    });

    return sum;
  }
}