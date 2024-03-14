// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/model/user/user_model.dart' as model;
import 'package:quickmed/provider/user/user_appstate.dart';

// this is a loading widget that that gives a loading screen
class SpLoading extends StatefulWidget {
  const SpLoading({
    Key? key,
  }) : super(key: key);

  @override
  State<SpLoading> createState() => _SpLoadingState();
}

class _SpLoadingState extends State<SpLoading> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserAppProvider user = Provider.of<UserAppProvider>(context, listen: false);
    model.UserModel? app = Provider.of<UserAppProvider>(context, listen: false).getUser;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 120,
            width: double.infinity,
            color: Colors.white,
            child: const SpinKitFadingCircle(
              color: Colors.blue,
              size: 40,
            )),
        //elevated button
        const SizedBox(height: 100,),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          onPressed: () {
            user.declineRequest(app!.id);
          },
          child: const Text(
            "Cancle Request",
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        )
      ],
    );
  }
}
