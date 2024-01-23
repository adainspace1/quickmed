import 'package:flutter/material.dart';
import 'package:quickmed/model/user/user_model.dart';
import 'package:quickmed/service/user/user_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  final UserDataBaseServices _userDataBaseService = UserDataBaseServices();

  UserModel? get getUser => _user;




  Future<void> refreshUser() async {
    UserModel user = await _userDataBaseService.getUserByUid();
    _user = user;
    notifyListeners();
  }



}
