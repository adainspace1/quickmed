// ignore_for_file: null_check_always_fails, unused_local_variable
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quickmed/controller/storage.dart';
import 'package:quickmed/model/chat.dart';
import 'package:quickmed/model/user/user_model.dart' as model;

class UserDataBaseServices {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // this function adds user to realtime database
  static Future addtoRealtime(model.UserModel user) async {
    try {
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
      databaseReference
          .child("users")
          .child("${user.id}")
          .update(user.toJson());

      // ignore: empty_catches
    } catch (e) {}
  }

  // this function add user to the firestore database
  static Future addUserToDatabase(model.UserModel user) async {
    try {
      var db = FirebaseFirestore.instance;
      await db
          .collection('users')
          .doc(user.id)
          .set(user.toJson(), SetOptions(merge: true));
      // ignore: empty_catches
    } catch (e) {}
  }

  //this function search for service providers basd on text input.........
  Future<QuerySnapshot> searchSp(String searchField) {
    return FirebaseFirestore.instance
        .collection("econsultants")
        .where('medicalField', isEqualTo: searchField)
        .limit(20)
        .get();
  }

  //get user by the id
  Future<model.UserModel> getUserByUid() async {
    User currentUser = _firebaseAuth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection("users").doc(currentUser.uid).get();

    return model.UserModel.fromSnapshot(snap);
  }

  //this function update the user location...........
  Future<void> updateLocation(double latitude, double longitude) async {
    User currentUser = _firebaseAuth.currentUser!;
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .update({'latitude': latitude, 'longitude': longitude});
  }

  //searching for econsultants......
  Stream<QuerySnapshot> econsultantStream() {
    CollectionReference reference =
        FirebaseFirestore.instance.collection("econsultants");
    return reference.snapshots();
  }

  //this function gets the user stream to rebuild the ui.......
  Stream<model.UserModel> getUserStreamByUid() {
    User currentUser = _firebaseAuth.currentUser!;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return model.UserModel.fromSnapshot(doc);
      } else {
        return null!;
      }
    });
  }

  //this function update the user collection...........
  Future<void> updateData(
      String docId, String name, String address, String email) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .update({'name': name, 'address': address, 'email': email});
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

      // Update the Firestore user document with the new image URL....
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({'profileImageUrl': downloadUrl});
    } catch (e) {
      // Handle any errors
    }
  }

  Future<void> sendMessage({String? user, String? msg, Type? type}) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    User currentuser = _firebaseAuth.currentUser!;

    final Message message = Message(
        msg: msg!,
        toId: currentuser.uid,
        read: '',
        type: type!,
        sent: time,
        fromId: currentuser.uid);
  }
}
