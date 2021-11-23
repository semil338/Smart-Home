import 'package:cloud_firestore/cloud_firestore.dart';

// abstract class Database {
//   Future<void> setData(Task task);
//   Stream<List<Task?>> readData();
//   Future<void> deleteData(Task task);
// }

abstract class Database {
  Stream<DocumentSnapshot<Map<String, dynamic>?>?> readPersonalData(String uid);
  Future<void> addPersonalData(
      {required String uId,
      required String name,
      required String email,
     });
}

// String jobId() => DateTime.now().toIso8601String();

// class FirestoreDatabase implements Database {
//   FirestoreDatabase({required this.uid});
//   final String uid;

//   final firestore = FirebaseFirestore.instance;

//   @override
//   Future<void> setData(Task task) async {
//     final reference = firestore.doc("user/$uid/tasks/${task.taskId}/");

//     await reference.set(task.toMap());
//   }

//   @override
//   Future<void> deleteData(Task task) async {
//     await firestore.doc("user/$uid/tasks/${task.taskId}/").delete();
//   }

//   @override
//   Stream<List<Task?>> readData() {
//     final reference = firestore.collection("user/$uid/tasks");
//     final snapshots = reference.snapshots();
//     return snapshots.map((snapshot) => snapshot.docs.map((snapshot) {
//           final data = snapshot.data();
//           // ignore: unnecessary_null_comparison
//           return data != null
//               // return Task.fromMap(data, snapshot.id);
//               ? Task(
//                   title: data["title"],
//                   taskId: snapshot.id,
//                 )
//               : null;
//         }).toList());
//   }
// }

class PersonalDatabase implements Database {
  final firestore = FirebaseFirestore.instance;

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>?>?> readPersonalData(
      String uid) {
    return firestore.collection("user").doc(uid).snapshots();
  }

  @override
  Future<void> addPersonalData({
    required String uId,
    required String name,
    required String email,
  }) async {
    await firestore.doc("user/$uId/").set({
      "name": name,
      "email": email,
    });
  }
}
