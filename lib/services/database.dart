import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_home/models/category.dart';
import 'package:smart_home/models/devices.dart';
import 'package:smart_home/models/rooms.dart';
import 'package:smart_home/models/users.dart';

abstract class Database {
  Stream<List<Users>?> getDataOfUsers();
  Stream<List<SubCategory>?> getDevices(String id);
  Stream<List<Category>?> getCategory();
  Stream<Users?> getUser(String id);
  Stream<List<Room>?> getRooms(String path);
  Future<void> addPersonalData({
    required String uId,
    required String name,
    required String email,
  });
  Future<void> addImage({
    required String uId,
    required String url,
  });
}

class FirestoreDatabase implements Database {
  final firestore = FirebaseFirestore.instance;

  @override
  Stream<List<Users>?> getDataOfUsers() {
    final query = firestore.collection("user").snapshots();

    return query.map((snapshot) {
      if (snapshot.size != 0) {
        final result = snapshot.docs
            .map((snapshots) => Users.fromMap(snapshots.data(), snapshots.id))
            .toList();
        return result;
      } else {
        return null;
      }
    });
  }

  @override
  Stream<Users?> getUser(String id) {
    final query = firestore.collection("user").doc(id).snapshots();

    return query.map((event) => Users.fromMap(event.data(), event.id));
  }

  @override
  Stream<List<SubCategory>?> getDevices(String id) {
    final query = firestore.collection("category/$id/subCategory").snapshots();

    return query.map((snapshot) {
      if (snapshot.size != 0) {
        final result = snapshot.docs
            .map((snapshots) =>
                SubCategory.fromMap(snapshots.data(), snapshots.id))
            .toList();
        return result;
      } else {
        return null;
      }
    });
  }

  @override
  Stream<List<Category>?> getCategory() {
    final query = firestore.collection("category").snapshots();

    return query.map((snapshot) {
      if (snapshot.size != 0) {
        final result = snapshot.docs
            .map(
                (snapshots) => Category.fromMap(snapshots.data(), snapshots.id))
            .toList();
        return result;
      } else {
        return null;
      }
    });
  }

  @override
  Stream<List<Room>?> getRooms(String path) {
    final query = firestore.collection(path).snapshots();

    return query.map((snapshot) {
      if (snapshot.size != 0) {
        final result = snapshot.docs
            .map((snapshots) => Room.fromMap(snapshots.data(), snapshots.id))
            .toList();
        return result;
      } else {
        return null;
      }
    });
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

  @override
  Future<void> addImage({
    required String url,
    required String uId,
  }) async {
    await firestore.doc("user/$uId/").update({
      "photoURL": url,
    });
  }
}
