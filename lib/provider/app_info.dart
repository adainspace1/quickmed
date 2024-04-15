import 'package:flutter/material.dart';
import 'package:quickmed/model/direction_model.dart';

class AppInfo extends ChangeNotifier {
  AddressModel? pickUpLocation;
  AddressModel? dropOffLocation;

  AddressModel? userLocation;
  AddressModel? spLocation;

  void updatePickUpLocation(AddressModel pickUpModel) {
    pickUpLocation = pickUpModel;
    notifyListeners();
  }

  void updateDropOffLocation(AddressModel dropOffModel) {
    dropOffLocation = dropOffModel;
    notifyListeners();
  }

  void updateUserLocation(AddressModel usermodel) {
    userLocation = usermodel;
    notifyListeners();
  }

  void updateSpLocation(AddressModel spModel) {
    spLocation = spModel;
    notifyListeners();
  }
}
