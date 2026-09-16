import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Themes extends GetxController{

  static ThemeData customLight = ThemeData.light().copyWith(
      appBarTheme: AppBarTheme(backgroundColor: Colors.red,)
  );
  static ThemeData customDark = ThemeData.dark().copyWith(
      appBarTheme: AppBarTheme(backgroundColor: Colors.white,)

  );
}