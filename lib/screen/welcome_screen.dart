import 'package:flutter/material.dart';
import 'package:quickmed/component/animated_text.dart';
import 'package:quickmed/screen/signin_screen.dart';
import 'package:quickmed/widget/custom_screen.dart';
import 'package:quickmed/widget/welcome_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      child: Column(
        children: [
          Flexible(flex:8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 40.0
                ),

                child: const Center(child: AnimatedText()),
              )
          ),
          const Flexible(flex:2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(child:
                    WelcomeButton(
                      buttonText: "Sign In",
                    
                      onTap: SignInScreen(),
                    )
                    )
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}
