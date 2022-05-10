import 'package:cloud_firestore/cloud_firestore.dart';

class Expense{
  String id;
  String purpose;
  String mode;
  double cost;
  DateTime TravelDate;

  Expense({required this.id, required this.purpose, required this.mode, required this.cost, required this.TravelDate});

  Expense.fromMap(Map <String, dynamic> snapshot, String id): 
  id = id, 
  purpose = snapshot['purpose'] ?? '',
  mode = snapshot['mode'] ?? '',
  cost = snapshot['cost'] ?? '',
  TravelDate = (snapshot['travelDate'] ?? Timestamp.now() as Timestamp).toDate();
}