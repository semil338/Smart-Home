import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

abstract class Realtime {
  DatabaseReference getData(String uid, String roomId);
  Stream<Event> number(String uid, String roomId);
  Future<void> setData(String uid, String roomId, Map<String, dynamic> data);
  Future<void> setValueField({
    required String uid,
    required String roomId,
    required String value,
    required String sId,
  });
  Future<void> deleteSwitch(String uid, String roomId, String sId);
  Future<void> updateData({
    required String uid,
    required String roomId,
    required String sId,
    required Map<String, dynamic> data,
  });
}

class RealtimeDatabase extends Realtime {
  final _databaseReference = FirebaseDatabase.instance.reference();

  @override
  Stream<Event> number(String uid, String roomId) {
    return _databaseReference
        .child("Switches")
        .child(uid)
        .child(roomId)
        .onValue;
  }

  @override
  DatabaseReference getData(String uid, String roomId) {
    return _databaseReference.child("Switches").child(uid).child(roomId);
  }

  @override
  Future<void> setData(
      String uid, String roomId, Map<String, dynamic> data) async {
    return await _databaseReference
        .child("Switches")
        .child(uid)
        .child(roomId)
        .push()
        .set(data);
  }

  @override
  Future<void> updateData({
    required String uid,
    required String roomId,
    required String sId,
    required Map<String, dynamic> data,
  }) async {
    return await _databaseReference
        .child("Switches")
        .child(uid)
        .child(roomId)
        .child(sId)
        .update(data);
  }

  @override
  Future<void> setValueField({
    required String uid,
    required String roomId,
    required String value,
    required String sId,
  }) async {
    return await _databaseReference
        .child("Switches")
        .child(uid)
        .child(roomId)
        .child(sId)
        .update({
      "value": value,
    });
  }

  @override
  Future<void> deleteSwitch(String uid, String roomId, String sId) async {
    return await _databaseReference
        .child("Switches")
        .child(uid)
        .child(roomId)
        .child(sId)
        .remove();
  }
}
