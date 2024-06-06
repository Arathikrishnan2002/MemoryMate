import 'package:flutter/material.dart';

class ScreenSizeUtil {
  // utility class
  /// init in the MaterialApp
  static late BuildContext context;                                    //initialized before it's used

  static get screenWidth => MediaQuery.of(context).size.width;

  static get screenHeight => MediaQuery.of(context).size.height;
}
