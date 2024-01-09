import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  textTheme: GoogleFonts.robotoTextTheme()
      .apply(bodyColor: const Color.fromARGB(255, 0, 0, 0)),
  colorScheme: ColorScheme.fromSeed(
    background: Colors.white,
    seedColor: Color.fromARGB(255, 33, 204, 158),
    primary: Color.fromARGB(255, 33, 204, 158),
    // brightness: Brightness.light,
  ),
);
