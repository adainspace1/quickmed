import 'package:flutter/material.dart';
import 'package:quickmed/util/constant.dart';

class TreatMent extends StatefulWidget {
  const TreatMent({super.key});

  @override
  State<TreatMent> createState() => _TreatMentState();
}

class _TreatMentState extends State<TreatMent> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
        backgroundColor: COLOR_ACCENT,
        title: const Text("Treatment",style: TextStyle(color: COLOR_BACKGROUND),),
      ),
    );
  }
}