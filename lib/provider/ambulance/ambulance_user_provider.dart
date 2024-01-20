import 'package:flutter/material.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart';
import 'package:quickmed/screen/ambulance/service/ambulance_service.dart';

class AmbulanceProvider extends ChangeNotifier {
  DriverModel? _user;
  final AmbulanceDatabaseService _databaseService = AmbulanceDatabaseService();

  DriverModel get getUser => _user!;

  int _rating = 0;

  int get rating => _rating;




  Future<void> refreshUser() async {
    DriverModel user = await _databaseService.getUserByUid();
    _user = user;
    notifyListeners();
  }

    void updateVotesAndRating(int newRating) {
      _rating = newRating;
      notifyListeners();
    
  }





}
