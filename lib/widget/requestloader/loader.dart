// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// this is a loading widget that that gives a loading screen
class SpLoading extends StatelessWidget {
  

  const SpLoading({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      color: Colors.white,
      child: const SpinKitFadingCircle(
        color: Colors.blue,
        size: 100,
      )
    );
  }
}
