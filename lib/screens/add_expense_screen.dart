import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transport_expense_tracker/all_expense.dart';
import 'package:transport_expense_tracker/widgets/expenses_list.dart';
import 'package:provider/provider.dart';


class AddExpenseScreen extends StatefulWidget {

  

  static String routeName = '/add-expense';

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  var form = GlobalKey<FormState>();

  String? purpose;
  String? mode;
  double? cost;
  DateTime? travelDate;

  void saveForm(AllExpenses expensesList) {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();
      if (travelDate == null) travelDate = DateTime.now();

      expensesList.addExpense(purpose,mode,cost,travelDate);

      // Hide the keyboard
      FocusScope.of(context).unfocus();

      //reset the form
      form.currentState!.reset();
      travelDate = null;

      //shows a snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Travel expense added successfully!'),
      ));
    }
  }

  void presentDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 14)),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        travelDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
        actions: [
          IconButton(onPressed: saveForm, icon: Icon(Icons.save))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: form,
          child: Column(
            children: [
              DropdownButtonFormField(
                decoration: InputDecoration(
                  label: Text('Mode of Transport'),
                ),
                items: [
                  DropdownMenuItem(
                    child: Text('Bus'),
                    value: 'bus',
                  ),
                  DropdownMenuItem(
                    child: Text('Grab'),
                    value: 'grab',
                  ),
                  DropdownMenuItem(
                    child: Text('MRT'),
                    value: 'mrt',
                  ),
                  DropdownMenuItem(
                    child: Text('Taxi'),
                    value: 'taxi',
                  ),
                ],
                validator: (value) {
                  if (value == null) {
                    return "Please provide a mode of transport";
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  mode = value as String;
                },
              ),
              TextFormField(
                decoration: InputDecoration(label: Text('cost')),
                keyboardType:
                    TextInputType.number, // make the keyboard number only
                validator: (value) {
                  if (value == null) {
                    return "Please provide a valid travel cost";
                  } else if (double.tryParse(value) == null) {
                    return "Plewase provide a valid travel cost.";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  cost = double.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(label: Text('Purpose')),
                validator: (value) {
                  if (value == null) {
                    return "Please enter a description that is at least 5 characters.";
                  } else if (value.length < 5) {
                    return 'Please enter a description that is at least 5 characters';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  purpose = value;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(travelDate == null
                      ? 'No Date Chosen'
                      : "picked date: " +
                          DateFormat('dd/MM/yyyy').format(travelDate!)),
                  TextButton(
                      child: Text('Choose Date',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        presentDatePicker(context);
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}