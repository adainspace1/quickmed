import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quickmed/model/user/user_model.dart' as model;

class UserDataBaseServices {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  //this function search for service providers.........
  Future<QuerySnapshot> searchSp(String searchField) {
    return FirebaseFirestore.instance
        .collection("econsultants")
        .where('medicalField', isEqualTo: searchField)
        .limit(20)
        .get();
  }
  //searching for econsultants......
  Stream<QuerySnapshot> econsultantStream() {
    CollectionReference reference = FirebaseFirestore.instance.collection("econsultants");
    return reference.snapshots();
  }

  //this function gets user UID
  Future<model.UserModel> getUserByUid() async {
    User currentUser = _firebaseAuth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection("users").doc(currentUser.uid).get();

    return model.UserModel.fromSnapshot(snap);
  }

  //this function update the user collection...........
  Future<void> updateData(String docId, String name)async {
     FirebaseFirestore.instance.collection('users').doc(docId).update({
        'name': name,
      
    });

  

  }

 
}
