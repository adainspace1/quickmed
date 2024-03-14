// ignore_for_file: null_check_always_fails

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:quickmed/controller/storage.dart';
import 'package:quickmed/model/e-consultant/econsultant_model.dart' as model;

class EconsultantServices {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // this function adds user to realtime database
  static Future addtoRealtime(model.EconsultantModel user) async {
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


   //get user by the id
  Future<model.EconsultantModel> getUserByUid() async {
    User currentUser = _firebaseAuth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection("econsultants").doc(currentUser.uid).get();

      return model.EconsultantModel.fromSnapshot(snap);
  }

  //this function gets the econsultant stream stream
  Stream<model.EconsultantModel> getUserStreamByUid() {
    User currentUser = _firebaseAuth.currentUser!;

    return FirebaseFirestore.instance
        .collection('econsultants')
        .doc(currentUser.uid)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return model.EconsultantModel.fromSnapshot(doc);
      } else {
        return null!;
      }
    });
  }


  // update online or last active status of user
  Future<void> updateActiveStatus(bool isOnline) async {
    User currentUser = _firebaseAuth.currentUser!;
    FirebaseFirestore.instance
        .collection('econsultants')
        .doc(currentUser.uid)
        .update({'is_Online': isOnline, 'timeStamp': Timestamp.now()});
  }

  //this function update the econsultant collection...........
  Future<void> updateData(String docId, String name, 
      String address, String email) async {
    FirebaseFirestore.instance.collection('econsultants').doc(docId).update(
        {'name': name,  'address': address, 'email': email});
  }

  //this function update the econsultant location...........
  //this function update the user location...........
  Future<void> updateLocation(double latitude, double longitude) async {
    User currentUser = _firebaseAuth.currentUser!;
    FirebaseFirestore.instance
        .collection('econsultants')
        .doc(currentUser.uid)
        .update({'latitude': latitude, 'longitude': longitude});
  }

  // Update user's profile image
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
          .collection('econsultants')
          .doc(currentUser.uid)
          .update({'img': downloadUrl});
    } catch (e) {
      // Handle any errors
    }
  }


Stream<QuerySnapshot> econsultantStream() {
    CollectionReference reference = FirebaseFirestore.instance.collection("econsultants");
    return reference.snapshots();
  }

}
