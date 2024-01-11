// ignore_for_file: constant_identifier_names, prefer_final_fields

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart';
import 'package:quickmed/model/ride_request.dart';
import 'package:quickmed/model/user/user_model.dart';
import 'package:quickmed/services/driver.dart';
import 'package:quickmed/services/ride_request_service.dart';

enum Show {
  SHOW_MODAL,
  USER_FOUND,
}

// ignore: duplicate_ignore
class AppState extends ChangeNotifier {
  static const ACCEPTED = 'accepted';
  static const CANCELLED = 'cancelled';
  static const PENDING = 'pending';
  static const EXPIRED = 'expired';

  Show show = Show.SHOW_MODAL;

  //  Driver request related variables
  bool lookingForDriver = false;
  bool alertsOnUi = false;
  bool userFound = false;

  RideRequest _requestServices = RideRequest();
  // ignore: unused_field
  DriverService _driverService = DriverService();

  String requestStatus = "";

  //  this variable will listen to the status of the ride request
  late StreamSubscription<QuerySnapshot> requestStream;
  // this variable will keep track of the drivers position before and during the ride
  late StreamSubscription<QuerySnapshot> userStream;
//  this stream is for all the driver on the app
  late StreamSubscription<List<DriverModel>> allUserStream;

  late DriverModel driverModel;
  late RideRequestModel rideRequestModel;
    //when request end
    showRequestExpiredAlert(BuildContext context) {
    if (alertsOnUi) Navigator.pop(context);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: const SizedBox(
              height: 200,
              child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                         "DRIVERS NOT FOUND! \n TRY REQUESTING AGAIN")
                    ],
                  )),
            ),
          );
        });
  }

  // this is listening to request
  listenToRequest({String? id, BuildContext? context}) {
    requestStream = _requestServices.requestStream()!.listen((querySnapshot) {
      // ignore: avoid_function_literals_in_foreach_calls
      querySnapshot.docChanges.forEach((doc) async {
        Map<String, dynamic>? data = doc.doc.data() as Map<String, dynamic>?;

        if (data?['id'] == id) {
          rideRequestModel = RideRequestModel.fromSnapshot(doc.doc);
          notifyListeners();
          switch (data?['status']) {
            case CANCELLED:
              break;
            case ACCEPTED:
              if (lookingForDriver) Navigator.pop(context!);
              lookingForDriver = false;
              driverModel = _driverService
                  .getDriverById(data?['driverId']) as DriverModel;

            case EXPIRED:
              await  showRequestExpiredAlert(context!);
              break;
            default:
              break;
          }
        }
      });
    });
  }

  requestDriver({UserModel? user}){

  }

  // ANCHOR LISTEN TO DRIVER
  // _listemToDrivers() {
  //   allUserStream = _driverService.getDrivers().listen();
  // }
}
