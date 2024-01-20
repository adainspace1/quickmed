// ignore_for_file: deprecated_member_use, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// const color
const COLOR_PRIMARY = Color.fromRGBO(251, 38, 19, 1);
const COLOR_ACCENT =  Colors.orange;
const COLOR_BACKGROUND_DARK = Color(0xFF171822);
const COLOR_BACKGROUND = Colors.white;
const COLOR_BACKGROUND_LIGHT = Color(0xFFF1F3F6);
const COLOR_BLUE = Colors.blue;

// Custom Fonts
const TextStyle customTextStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 16.0,
  fontWeight: FontWeight.normal,
);

final TextStyle customBoldTextStyle = customTextStyle.copyWith(
  fontWeight: FontWeight.bold,
);

// Example: Custom Google Font
final TextStyle customGoogleFontStyle = GoogleFonts.montserrat(
  textStyle: customTextStyle,
);

final TextStyle customGoogleFontBoldStyle = GoogleFonts.montserrat(
  textStyle: customBoldTextStyle,
);

class Constants{

  static String myName = "";
}