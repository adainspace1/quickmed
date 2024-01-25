import 'package:flutter/material.dart';
import 'package:quickmed/model/e-consultant/econsultant_model.dart';
import 'package:quickmed/service/econsultant/econ_service.dart';

class EconsultantProvider extends ChangeNotifier {
  EconsultantModel? _user;

  final EconsultantServices _econsultantServices = EconsultantServices();

  EconsultantModel? get getUser => _user;




  Future<void> refreshUser() async {
    EconsultantModel user = await _econsultantServices.getUserByUid();
    _user = user;
    notifyListeners();
  }



}
