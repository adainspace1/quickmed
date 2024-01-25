import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quickmed/model/e-consultant/econsultant_model.dart' as model;

class EconsultantServices {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // this function adds user to realtime database
static  Future addtoRealtime(model.EconsultantModel user) async {
    try {
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
      databaseReference
          .child("${user.name}")
          .child("${user.name}")
          .update(user.toJson());
      // ignore: empty_catches
    } catch (e) {}
  }

  // this function add user to the firestore database
  static Future addUserToDatabase(model.EconsultantModel user) async {
    try {
      var db = FirebaseFirestore.instance;
      //await db.collection('users').add(user.toJson());
      await db
          .collection('econsultants')
          .doc(user.id)
          .set(user.toJson(), SetOptions(merge: true));
      // ignore: empty_catches
    } catch (e) {}
  }

    //this function gets user UID
  Future<model.EconsultantModel> getUserByUid() async {
    User currentUser = _firebaseAuth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection("econsultants").doc(currentUser.uid).get();

    return model.EconsultantModel.fromSnapshot(snap);
  }



  // update online or last active status of user
  Future<void> updateActiveStatus( bool isOnline) async {  
   User currentUser = _firebaseAuth.currentUser!;
   FirebaseFirestore.instance.collection('econsultants').doc(currentUser.uid).update({
      'is_Online': isOnline,
      'timeStamp': Timestamp.now()
    });
    
  }

   Future<void> updateLocation( double latitude, double longitude) async {  
   User currentUser = _firebaseAuth.currentUser!;
   FirebaseFirestore.instance.collection('econsultants').doc(currentUser.uid).update({
      'latitude': latitude,
      'longitude': longitude
    });
    
  }
}
