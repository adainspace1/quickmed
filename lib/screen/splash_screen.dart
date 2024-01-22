import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickmed/screen/signin_screen.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/helpers/screen_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
    Future.delayed(const Duration(seconds: 6), () {
      changeScreenReplacement(context, const SignInScreen());
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [COLOR_BACKGROUND, Color.fromARGB(255, 219, 216, 216)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/logo.png", width: 100, height: 100,)

          ],
        ),
      ),
    );
  }
}
