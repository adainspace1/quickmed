import 'package:flutter/material.dart';
import 'package:quickmed/util/constant.dart';

class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text(
          "SUBSCRIPTION",
          style: TextStyle(fontSize: 14.0, color: Colors.white),
        ),
      ),
      backgroundColor: COLOR_ACCENT,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(30, 40, 40, 40),
            child: const Center(
              child: Text(
                "Enjoy a Premium QuickMed Service",
                style: TextStyle(color: COLOR_BACKGROUND, fontSize: 20),
              ),
            ),
          ),
          CustomCard(text: "Get Verified for 5000 Naira", onPress: () => {}),
          CustomCard(text: "Get Verified for 5000 Naira", onPress: () => {}),
          CustomCard(text: "Get Verified for 5000 Naira", onPress: () => {}),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String text;
  final VoidCallback onPress;

  const CustomCard({super.key, required this.text, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPress,
        child: Card(
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 150,
                    height: 100,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: const Icon(Icons.star)),
                Text(
                  text,
                  style: const TextStyle(fontSize: 16.0, fontFamily: 'Lato'),
                ),
              ],
            ),
          ),
        ));
  }
}
