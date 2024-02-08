import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class NotificationMessage{


// this is a toast message for errorOtp
  // ignore: non_constant_identifier_names
  void OtpError(){
    Fluttertoast.showToast(
        msg: "An error occurred while sending OTP",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

    void error(){
    Fluttertoast.showToast(
        msg: "Fields cannot be empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }


  void success(){
    Fluttertoast.showToast(
        msg: "Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  
}