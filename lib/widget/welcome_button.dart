import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickmed/util/constant.dart';
// this is a welcome button widget that wraps the sign up page
class WelcomeButton extends StatelessWidget {
    const WelcomeButton({super.key, this.buttonText, this.onTap, this.color, this.textColor});
  final String? buttonText;
  final Widget? onTap;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (e) => onTap!,
          ),
        );
      },
      child:  Container(
        padding: const EdgeInsets.all(30.0),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50)
            )
        ),
        child: Text(
          buttonText!,
          textAlign: TextAlign.center,
          style:  GoogleFonts.lato(
              color: COLOR_BLUE,
              fontSize: 20,
              fontWeight: FontWeight.w700
              
          ),
        ),

      ),
    );
  }
}

