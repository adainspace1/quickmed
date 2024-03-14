import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:quickmed/controller/storage.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart' as model;

class AmbulanceDatabaseService {

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

 

 //this function gets the user stream to rebuild the ui.......
  Stream<model.DriverModel> getUserStreamByUid() {
    User currentUser = _firebaseAuth.currentUser!;

    return FirebaseFirestore.instance
        .collection('ambulance')
        .doc(currentUser.uid)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return model.DriverModel.fromSnapshot(doc);
      } else {
        // ignore: null_check_always_fails
        return null!;
      }
    });
  }

    Future<void> updateLocation(double latitude, double longitude) async {
    User currentUser = _firebaseAuth.currentUser!;
    FirebaseFirestore.instance
        .collection('ambulance')
        .doc(currentUser.uid)
        .update({'latitude': latitude, 'longitude': longitude});
  }



  //this function update the user collection...........
  Future<void> updateData(String docId, String name, String address, String email) async {
    FirebaseFirestore.instance.collection('ambulance').doc(docId).update({
      'name': name,
      'address': address,
      'email': email
      
    });
  }
  
  static Future<void> updateProfileImage(Uint8List file) async {
    try {
      User currentUser = _firebaseAuth.currentUser!;

      // Create StorageMethod instance for image upload
      StorageMethod storageMethod = StorageMethod();

      // Upload the new profile image to Firebase Storage
      String downloadUrl = await storageMethod.uploadImageToStorage(
          'profile_images', file, false);

      // Update the user's profile with the new image URL
      // ignore: deprecated_member_use
      await _firebaseAuth.currentUser!.updateProfile(photoURL: downloadUrl);

      // Reload the user to get the updated information
      await _firebaseAuth.currentUser!.reload();

      // Update the Firestore user document with the new image URL
      await FirebaseFirestore.instance
          .collection('ambulance')
          .doc(currentUser.uid)
          .update({'profileImageUrl': downloadUrl});
    } catch (e) {
      // Handle any errors
    }
  }

    // update online or last active status of user
  Future<void> updateActiveStatus(bool isOnline) async {
    User currentUser = _firebaseAuth.currentUser!;
    FirebaseFirestore.instance
        .collection('econsultants')
        .doc(currentUser.uid)
        .update({'is_Online': isOnline, 'timeStamp': Timestamp.now()});
  }
  
}