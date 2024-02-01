// ignore_for_file: prefer_final_fields, unused_field, constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:quickmed/model/user/user_model.dart';
import 'package:quickmed/service/user/user_service.dart';

enum Show { SP_FOUND, SEND_REQUEST }

class UserAppProvider extends ChangeNotifier {
/*state management for the chat-app...  
  i declear a private variable called _message..
*/
  String? _message;
  String? get message => _message;

/* i want to call the userDatabase service*/
  UserDataBaseServices _services = UserDataBaseServices();

/* i want to get my usermodel */
  UserModel? _user;
  UserModel? get getUser => _user;

/* i want to test the wallet with state  */
  int? _amount;
  int? get amount => _amount;

/*draggable to show when service provider is seen*/
  Show show = Show.SP_FOUND;


  Future<void> refreshUser() async {
    UserModel user = await _services.getUserByUid();
    _user = user;
    notifyListeners();
  }


  getSpLocation(){
    
  }
}
