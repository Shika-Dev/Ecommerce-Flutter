import 'package:flutter/material.dart';

class CusTextStyle {
  static TextStyle bodyText = TextStyle(
      fontFamily: 'JosefinSans',
      fontSize: 16,
      color: CusColor.darkBlue,
      fontWeight: FontWeight.w400);

  static TextStyle itemText = TextStyle(
      fontFamily: 'JosefinSans',
      fontSize: 16,
      color: CusColor.blue,
      fontWeight: FontWeight.w400);

  static TextStyle navText = TextStyle(
      fontFamily: 'Lato',
      fontSize: 16,
      color: CusColor.darkBlue,
      fontWeight: FontWeight.w400);
}

class CusColor {
  static Color darkBlue = Color(0xff0D0E43);
  static Color blue = Color(0xff151875);
  static Color green = Color(0xff7CE5BD);
  static Color red = Color(0xffFB2448);
  static Color border = Color(0xffE7E6EF);
  static Color disable = Color(0xff151875).withOpacity(.3);
}

class CusBoxShadow {
  static BoxShadow shadow = BoxShadow(
      offset: Offset(0, 8),
      color: Color(0xff31208A).withOpacity(.05),
      blurRadius: 40,
      spreadRadius: 0);
}
