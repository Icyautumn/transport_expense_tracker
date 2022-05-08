import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'expense.dart';
import 'package:transport_expense_tracker/widgets/expenses_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var form = GlobalKey<FormState>();

  String? purpose;

  String? mode;

  double? cost;

  DateTime? travelDate;

  List<Expense> myExpenses = [];

  void saveForm() {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();
      if (travelDate == null) travelDate = DateTime.now();
      print(purpose);
      print(mode);
      print(cost!.toStringAsFixed(2));

      myExpenses.insert(
          0,
          Expense(
              purpose: purpose!,
              mode: mode!,
              cost: cost!,
              TravelDate: travelDate!));

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

  void removeItem(i) {
    // press the delete button
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // ask user 
            title: Text('Confirmation'),
            content: Text('Are you sure you want to delete'),
            actions: [
                  // if no
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
              // if yes
              TextButton(
                  onPressed: () {
                    setState(() {
                      myExpenses.removeAt(i);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Yes')),
            ],
          );
        });
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Transport Expense Tracker'),
          actions: [
            IconButton(onPressed: saveForm, icon: Icon(Icons.save)),
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
                Expanded(
                    child: myExpenses.length > 0
                        ? Container(
                            height: 200,
                            child: ExpensesList(myExpenses, removeItem),
                          )
                        : Column(
                            children: [
                              SizedBox(height: 20),
                              Image.asset('images/picture.png', width: 300),
                              Text('No Expenses yet, add a new one today!',
                                  style: Theme.of(context).textTheme.subtitle1),
                            ],
                          )),
              ],
            ),
          ),
        ));
  }
}
