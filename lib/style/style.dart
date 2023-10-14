import 'package:flutter/material.dart';

class CusTextStyle {
  static TextStyle bodyText = TextStyle(
      fontFamily: 'JosefinSans',
      fontSize: 16,
      color: CusColor.black,
      fontWeight: FontWeight.w400);

  static TextStyle itemText = TextStyle(
      fontFamily: 'JosefinSans',
      fontSize: 16,
      color: CusColor.black,
      fontWeight: FontWeight.w400);

  static TextStyle navText = TextStyle(
      fontFamily: 'Lato',
      fontSize: 16,
      color: CusColor.black,
      fontWeight: FontWeight.w400);
}

class CusColor {
  static Color black = Color(0xff000000);
  static Color darkBlue = Color(0xff1f475c);
  static Color blue = Color(0xff151875);
  static Color green = Color(0xff00605d);
  static Color red = Color(0xffFB2448);
  static Color border = Color(0xffE7E6EF);
  static Color bgShade = Color(0xffF6F5FF);
  static Color footerText = Color(0xff8A8FB9);
  static Color disable = Color(0xff151875).withOpacity(.3);
}

class CusBoxShadow {
  static BoxShadow shadow = BoxShadow(
      offset: Offset(0, 8),
      color: Color(0xff31208A).withOpacity(.05),
      blurRadius: 40,
      spreadRadius: 0);
}
