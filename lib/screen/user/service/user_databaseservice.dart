import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickmed/model/user/user_model.dart' as model;

class UserServices {
  // this function adds user to realtime database
  static Future addtoRealtime(model.UserModel user) async {
    try {
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
      databaseReference
          .child("${user.phone}")
          .child("${user.name}")
          .update(user.toJson());
      // ignore: empty_catches
    } catch (e) {}
  }

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData(LatLng position) async {
    return await usersCollection.doc().set({
      'latitude': position.latitude,
      'longitude': position.longitude,
    });
  }

  // this function add user to the firestore database
  static Future addUserToDatabase(model.UserModel user) async {
    try {
      var db = FirebaseFirestore.instance;
      //await db.collection('users').add(user.toJson());
      await db
          .collection('users')
          .doc(user.id)
          .set(user.toJson(), SetOptions(merge: true));
      // ignore: empty_catches
    } catch (e) {}
  }


  Future<QuerySnapshot> searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("econsultant")
        .where('medicalField', isGreaterThanOrEqualTo: searchField)
        .limit(20)
        .get();
  }

    Stream<QuerySnapshot> econsultantStream(String text) {
    CollectionReference reference = FirebaseFirestore.instance.collection("econsultant");
    return reference.snapshots();
  }
}
