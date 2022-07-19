import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transport_expense_tracker/models/lesson_detail.dart';
import 'package:transport_expense_tracker/services/auth_service.dart';

class FirestoreService {
  AuthService authService = AuthService();

  addExpense(lessonType, lessonDetail, lessonImage, dateCreated, studentEmail) {
    print(dateCreated);
    return FirebaseFirestore.instance.collection('LessonDetail').add({
      'teacherEmail' : authService.getCurrentUser()!.email ,
      'lessonType': lessonType,
      'LessonDetail': lessonDetail,
      'lessonImage': lessonImage,
      'dateCreated': dateCreated,
      'studentEmail': studentEmail,
    });
  }

  removeExpense(id) {
    return FirebaseFirestore.instance.collection('LessonDetail').doc(id).delete();
  }

  Stream<List<LessonDetail>> getLessonDetail() {
    return FirebaseFirestore.instance.collection('LessonDetail')
    .where('teacherEmail', isEqualTo: authService.getCurrentUser()!.email).
    snapshots().map(
        (snapshot) => snapshot.docs
            .map<LessonDetail>((doc) => LessonDetail.fromMap(doc.data(), doc.id))
            .toList());
  }

  editExpense(id, dateCreated, lessonType, studentEmail, lessonImage, lessonDetail) {
    return FirebaseFirestore.instance.collection('LessonDetail').doc(id).set({
      'teacherEmail' : authService.getCurrentUser()!.email ,
      'lessonType': lessonType,
      'LessonDetail': lessonDetail,
      'lessonImage': lessonImage,
      'dateCreated': dateCreated,
      'studentEmail': studentEmail,
    });
  }
}
