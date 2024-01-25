import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickmed/model/user/user_model.dart';
import 'package:quickmed/service/user/user_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  final UserDataBaseServices _userDataBaseService = UserDataBaseServices();

  UserModel? get getUser => _user;

  QuerySnapshot? _searchResultSnapshot;

  QuerySnapshot? get searchResultSnapshot => _searchResultSnapshot;


  Future<void> refreshUser() async {
    UserModel user = await _userDataBaseService.getUserByUid();
    _user = user;
    notifyListeners();
  }


    Future<void> setSearchResult(String text) async {
    try {
      // ignore: await_only_futures
      var snapshot = await UserDataBaseServices().searchSp(text);
      _searchResultSnapshot = snapshot;
      notifyListeners();
    
    // ignore: empty_catches
    } catch (e) {
    }
  }

}
