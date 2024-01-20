import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart' as model;

class AmbulanceDatabaseService {

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // this function adds user to realtime database
  static Future addtoRealtime(model.DriverModel user) async {
    try {
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
      databaseReference
          .child("${user.phone}")
          .child("${user.name}")
          .update(user.toJson());
      // ignore: empty_catches
    } catch (e) {}
  }
  // funciion that adds user to the database
  static Future addUserToDatabase(model.DriverModel user) async {
    try {
      var db = FirebaseFirestore.instance;
      //await db.collection('users').add(user.toJson());
      await db
          .collection('ambulance')
          .doc(user.id)
          .set(user.toJson(), SetOptions(merge: true));
      // ignore: empty_catches
    } catch (e) {}
  }

  //this function gets user UID
  Future<model.DriverModel> getUserByUid() async {
    
    User currentUser = _firebaseAuth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection("ambulance").doc(currentUser.uid).get();

        return model.DriverModel.fromSnapshot(snap);
  }


  
}