// ignore_for_file: prefer_final_fields, constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class RideRequestModel {
  static const ID = "id";
  static const USERNAME = "username";
  static const USER_ID = "userId";
  static const DRIVER_ID = "driverId";
  static const STATUS = "status";
  static const POSITION = "position";
  static const DESTINATION = "destination";

  String _id = "";
  String _username = "";
  String _userId = "";
  String _driverId = "";
  String _status = "";
  Map<String, dynamic> _position = {};
  Map<String, dynamic> _destination = {};

  String get id => _id;
  String get username => _username;
  String get userId => _userId;
  String get driverId => _driverId;
  String get status => _status;
  Map<String, dynamic> get position => _position;
  Map<String, dynamic> get destination => _destination;

  RideRequestModel.fromSnapshot(DocumentSnapshot snapshot)
      : _id = snapshot[ID] as String? ?? "",
        _username = snapshot[USERNAME] as String? ?? "",
        _userId = snapshot[USER_ID] as String? ?? "",
        _driverId = snapshot[DRIVER_ID] as String? ?? "",
        _status = snapshot[STATUS] as String? ?? "",
        _position = snapshot[POSITION] as Map<String, dynamic>? ?? {},
        _destination = snapshot[DESTINATION] as Map<String, dynamic>? ?? {};
}
