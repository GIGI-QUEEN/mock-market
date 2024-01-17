import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  textTheme: GoogleFonts.openSansTextTheme()
      .apply(bodyColor: const Color.fromARGB(255, 0, 0, 0)),
  colorScheme: ColorScheme.fromSeed(
    background: Colors.white,
    seedColor: const Color.fromARGB(255, 33, 204, 158),
    primary: const Color.fromARGB(255, 33, 204, 158),
    tertiary: Colors.white,
    // brightness: Brightness.light,
  ),
);
