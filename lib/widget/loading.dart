import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// this is a loading widget that that gives a loading screen
class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const SpinKitFadingCircle(
        color: Colors.blue,
        size: 30,
      )
    );
  }
}
