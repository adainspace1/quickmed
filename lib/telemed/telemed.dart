import 'package:flutter/material.dart';
import 'package:quickmed/global/global.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class TeleMedic extends StatelessWidget {
  const TeleMedic(
      {super.key, required String userId, required String userName});

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 2040810976, // your AppID,
      appSign:
          '9ff66538dda95f9fe8867711e3001b4269b5df5a16a5e6cae539031bb643818c',
      userID: userID,
      userName: userName,
      callID: 'call id',
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
