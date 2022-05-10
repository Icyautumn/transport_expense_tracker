import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transport_expense_tracker/expense.dart';
import 'package:transport_expense_tracker/services/firestore_service.dart';
import 'package:provider/provider.dart';

class EditExpenseScreen extends StatefulWidget {
  static String routeName = '/edit-expense';

  @override
  // ignore: no_logic_in_create_state
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  var form = GlobalKey<FormState>();

  String? purpose;
  String? mode;
  double? cost;
  DateTime? travelDate;

  void saveForm(String id) {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();
      if (travelDate == null) travelDate = DateTime.now();

      FireStoreService fsService = FireStoreService();
      fsService.editExpense(id, purpose, mode, cost, travelDate);

      // Hide the keyboard
      FocusScope.of(context).unfocus();

      //reset the form
      form.currentState!.reset();
      travelDate = null;

      //shows a snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Travel expense updated successfully!'),
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
    Expense selectedExpense = ModalRoute.of(context)?.settings.arguments as Expense;
    travelDate = selectedExpense.TravelDate;
    return Scaffold(
      appBar: AppBar(
        title: Text('edit Expense'),
        actions: [IconButton(onPressed: () => saveForm(selectedExpense.id), icon: Icon(Icons.save))],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: form,
          child: Column(
            children: [
              DropdownButtonFormField(
                value: selectedExpense.mode,
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
                onSaved: (value){
                  mode = value as String;
                },
              ),
              TextFormField(
                initialValue: selectedExpense.cost.toStringAsFixed(2),
                decoration: InputDecoration(label: Text('cost')),
                keyboardType:
                    TextInputType.number, // make the keyboard number only
                validator: (value) {
                  if (value == null) {
                    return "Please provide a valid travel cost";
                  } else if (double.tryParse(value) == null) {
                    return "Please provide a valid travel cost.";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  cost = double.parse(value!);
                },
              ),
              TextFormField(
                initialValue: selectedExpense.purpose,
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
                      },),
                      
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
