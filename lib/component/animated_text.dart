import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AnimatedText extends StatefulWidget {
  const AnimatedText({super.key});

  final bool repeat = false;

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          width: 20.0,
          height: 20.0,
        ),
        DefaultTextStyle(
            style: const TextStyle(
                fontSize: 60.0, color: Colors.white),
            child: Center(
                child: AnimatedTextKit(
                  animatedTexts: [
                    ScaleAnimatedText("Quickmed"),
                  

                  ],
                  totalRepeatCount: 20,
                  pause: const Duration(milliseconds: 1000),
                )))
      ],
    );
  }
}
