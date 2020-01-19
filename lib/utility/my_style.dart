import 'package:flutter/material.dart';

class MyStyle {
  // Field
  Color textColor = Color.fromARGB(0xff, 0xc5, 0x60, 0x00);
  Color mainColor = Color.fromARGB(0xff, 0xff, 0xc0, 0x46);
  Color barColor = Color.fromARGB(0xff, 0xff, 0x8f, 0x00);

  TextStyle h1Text = TextStyle(
    fontFamily: 'Sarabun',
    color: Color.fromARGB(0xff, 0xc5, 0x60, 0x00),
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    fontSize: 30.0,
  );

  TextStyle h2Text = TextStyle(
    fontFamily: 'Sarabun',
    color: Color.fromARGB(0xff, 0xc5, 0x60, 0x00),
    // fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
  );

  // Method

  MyStyle();
}
