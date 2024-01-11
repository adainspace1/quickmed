import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart';

//i am creating a profile state


class AmbulanceProfileProvider extends ChangeNotifier {
  User? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _user;

  void initUser() {
    _user = _auth.currentUser; // Get the current user synchronously
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _user = user;
      }
    });
  }

  Future<DriverModel?> getUserByUid() async {
    try {
      if (_user == null) {
        return null;
      }

      var db = FirebaseFirestore.instance;
      var useRef = db.collection("ambulance").doc(_user!.uid);
      var snapShot = await useRef.get();

      if (snapShot.exists) {
        DriverModel user = DriverModel.fromSnapshot(snapShot);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

