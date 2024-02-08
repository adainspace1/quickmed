// ignore_for_file: prefer_final_fields, unused_field, constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quickmed/model/user/user_model.dart';
import 'package:quickmed/service/ride_request.dart';
import 'package:quickmed/service/user/user_service.dart';

// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

enum Show { SP_ACCEPTED, SEND_REQUEST }

class UserAppProvider extends ChangeNotifier {
  static const ACCEPTED = 'accepted';
  static const CANCELLED = 'cancelled';
  static const PENDING = 'pending';
  static const EXPIRED = 'expired';
/*THIS IS THE STATE
MANAGEMENT FOR MESSAGING...
*/
  String? _message;
  String? get message => _message;

/* THIS IS TO GET THE USERDATABASE SERVICES*/
  UserDataBaseServices _services = UserDataBaseServices();

// RIDEREQUEST SERVICE
  RideRequest _request = RideRequest();

/* THIS IS TO GET THE USERMODEL */
  UserModel? _user;
  UserModel? get getUser => _user;



/*THIS IS TO GET THE SPMODEL */



/* THIS IS TO MAINTAIN THE STATE OF THE WALLET  */
  int? _amount;
  int? get amount => _amount;

  bool alertsOnUi = false;
  bool lookingForDriver = false;
  bool driverFound = false;
  bool driverArrived = false;
  int timeCounter = 0;
  double percentage = 0;
  late Timer periodicTimer;

/*
THIS IS TO SHOW THE WIDGET WHEN THE USER IS FOUND
*/
  Show show = Show.SP_ACCEPTED;

  //FUNCTION TO GET THE USER FROM THE FIRESTORE DATABASE...
  Future<void> refreshUser() async {
    UserModel user = await _services.getUserByUid();
    _user = user;
    notifyListeners();
  }

  //FUNCTION TO SEND REQUEST
  void createRequest(String? issue, BuildContext context, UserModel user) {
    //TO GENERATE A UNIQUE ID FOR EACH REQUESTS..
    var uuid = const Uuid();
    String requestId = uuid.v1();

    //SEND RIDE REQUEST...
    _request.createRideRequest(
        id: requestId,
        userId: user.id,
        name: user.name,
        issue: issue,
        img: user.profileImageUrl);

    //Show UI indicating that a request is being sent
    showWaitingForResponseUI();
    //START TIMER FOR WAITING THE REQUEST...
    startWaitingTimer(user.id!, context);
  }

  void showWaitingForResponseUI() {
    //Update UI to indicate that a request is being sent
    alertsOnUi = true;
    notifyListeners();
  }

  void startWaitingTimer(String requestId, BuildContext context) {
    //Start the timer for waiting
    lookingForDriver = true;
    notifyListeners();

    periodicTimer = Timer.periodic(const Duration(seconds: 1), (time) {
      timeCounter = timeCounter + 1;
      percentage = timeCounter / 100;
      print("====== GOOOO $timeCounter");

      if (timeCounter == 100) {
        // WHEN THE TIMER RUNS OUT
        timeCounter = 0;
        percentage = 0;
        lookingForDriver = false;

        //UPDATE THE REQUEST TO EXPIRED...
        _request.upDateRequest(EXPIRED, requestId);

        //CANCEL TIMER....
        time.cancel();

        if (alertsOnUi) {
          alertsOnUi = false;
          notifyListeners();
        }
      }
      notifyListeners();
    });
  }

  //WHEN THE REQUEST HAS EXPIRED.....
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
                      Column(
                        children: [
                          Center(
                            child: Text(
                                "Request TimedOut! \n TRY REQUESTING AGAIN"),
                          )
                        ],
                      )
                    ],
                  )),
            ),
          );
        });
  }
}
