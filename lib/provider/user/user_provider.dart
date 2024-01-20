import 'package:flutter/material.dart';
import 'package:quickmed/controller/auth_service.dart';
import 'package:quickmed/model/user/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  final AuthService _authService = AuthService();

  UserModel get getUser => _user!;


  int _rating = 0;

  int get rating => _rating;

  Future<void> refreshUser() async {
    UserModel user = await _authService.getUserByUid();
    _user = user;
    notifyListeners();
  }



  void updateVotesAndRating( int newRating) {   
      _rating = newRating;
      notifyListeners();
    
  }
}
