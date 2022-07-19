import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transport_expense_tracker/models/lesson_detail.dart';
import 'package:transport_expense_tracker/screens/edit_lesson_detail_screen.dart';
import 'package:transport_expense_tracker/services/firestore_service.dart';
import 'package:expandable/expandable.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';

class ExpensesList extends StatefulWidget {
  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  FirestoreService fsService = FirestoreService();

  void removeItem(String id) {
    showDialog<Null>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      fsService.removeExpense(id);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<LessonDetail>>(
        stream: fsService.getLessonDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else {
            return ListView.separated(
              itemBuilder: (ctx, i) {
                return ExpandableNotifier(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: Colors.grey.withOpacity(0.2), width: 1)),
                      child: ScrollOnExpand(
                        child: ExpandablePanel(
                          theme: ExpandableThemeData(
                            tapBodyToCollapse: true,
                            tapBodyToExpand: true,
                          ),
                          header: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              DateFormat('yyyy-MM-dd')
                                  .format(snapshot.data![i].dateCreated!),
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // what it says when collapsed
                          collapsed: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                snapshot.data![i].lessonType!,
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(width: 1),
                              Text(
                                "By: " + snapshot.data![i].teacherEmail,
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),

                          expanded: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(snapshot.data![i].lessonType!),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Text(
                                    "By: " + snapshot.data![i].teacherEmail,
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // where more lesson details go and images
                              Text(snapshot.data![i].lessonDetail!),
                              FullScreenWidget(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                      snapshot.data![i].lessonImages!,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // edit lesson details
                                  TextButton(
                                      onPressed: () => Navigator.pushNamed(
                                          context, EditExpenseScreen.routeName,
                                          arguments: snapshot.data![i]),
                                      child: Text('Edit')),
                                  TextButton(
                                      onPressed: () =>
                                          removeItem(snapshot.data![i].id),
                                      child: Text('Delete'))
                                ],
                              )
                            ],
                          ),
                          builder: (_, collapsed, expanded) => Padding(
                            padding: const EdgeInsets.all(8.0).copyWith(top: 0),
                            child: Expandable(
                              collapsed: collapsed,
                              expanded: expanded,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: snapshot.data!.length,
              separatorBuilder: (ctx, i) {
                return Divider(height: 3, color: Colors.blueGrey);
              },
            );
          }
        });
  }
}


//   return ListTile(
              //     leading: CircleAvatar(
              //       child: Text(snapshot.data![i].mode),
              //     ),
              //     title: Text(snapshot.data![i].purpose),
              //     subtitle: Text(snapshot.data![i].cost.toStringAsFixed(2)),
              //     trailing: IconButton(
              //       icon: Icon(Icons.delete),
              //       onPressed: () {
              //         removeItem(snapshot.data![i].id);
              //       },
              //     ),
              //     onTap: () => Navigator.pushNamed(
              //         context, EditExpenseScreen.routeName,
              //         arguments: snapshot.data![i]),
              //   );