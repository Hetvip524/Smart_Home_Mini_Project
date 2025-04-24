import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }

  static double getResponsiveWidth(double width) {
    return (width / 375.0) * screenWidth;
  }

  static double getResponsiveHeight(double height) {
    return (height / 812.0) * screenHeight;
  }

  static double getAdaptiveTextSize(double size) {
    return (size / 375.0) * screenWidth;
  }
}

// Get proportionate height according to screen size
double getProportionateScreenHeight(double inputHeight) {
  return SizeConfig.getResponsiveHeight(inputHeight).clamp(0, SizeConfig.screenHeight);
}

// Get proportionate width according to screen size
double getProportionateScreenWidth(double inputWidth) {
  return SizeConfig.getResponsiveWidth(inputWidth).clamp(0, SizeConfig.screenWidth);
} 