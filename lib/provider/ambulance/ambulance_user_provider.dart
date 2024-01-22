import 'package:flutter/material.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart';
import 'package:quickmed/service/ambulance/ambulance_service.dart';

class AmbulanceProvider extends ChangeNotifier {
  DriverModel? _user;
  final AmbulanceDatabaseService _databaseService = AmbulanceDatabaseService();

  DriverModel get getUser => _user!;





  Future<void> refreshUser() async {
    DriverModel user = await _databaseService.getUserByUid();
    _user = user;
    notifyListeners();
  }







}
