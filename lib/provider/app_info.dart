import 'package:flutter/material.dart';
import 'package:quickmed/model/direction_model.dart';

class AppInfo extends ChangeNotifier {
  


  Directions? userPickUpLocation, userDropOffLocation;
  int countToltalTrip = 0;
  // List<String> historyTripKeyList = [];
  // List<String> allTripHistoryInformationList = [];

  
  // Initialize the user on app startup
 


  
  void upDatePickUpLocationAddress(Directions userPickUpAddress) {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void upDateDropOffLocationAddress(Directions dropOffUpAddress) {
    userDropOffLocation = dropOffUpAddress;
    notifyListeners();
  }
}


