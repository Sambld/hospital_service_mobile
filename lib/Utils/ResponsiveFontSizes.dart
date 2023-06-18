import 'package:flutter/material.dart';

class ResponsiveFontSize {
  static late double _screenWidth;

  static const double _baseFont = 14.0;

  static const double _xxSmall = 0.6;
  static const double _xSmall = 0.8;
  static const double _small = 0.9;
  static const double _medium = 1.0;
  static const double _large = 1.1;
  static const double _xLarge = 1.2;
  static const double _xxLarge = 1.4;
  static const double _xxxLarge = 1.8;


  static void initialize(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
  }

  static double xxSmall() {
    if (_screenWidth <= 480) {
      return _baseFont * _xxSmall;
    } else if (_screenWidth <= 720) {
      return _baseFont * _xSmall;
    } else {
      return _baseFont * _small;
    }
  }

  static double xSmall() {
    if (_screenWidth <= 480) {
      return _baseFont * _xSmall;
    } else if (_screenWidth <= 720) {
      return _baseFont * _small;
    } else {
      return _baseFont * _medium;
    }
  }

  static double small() {
    if (_screenWidth <= 480) {
      return _baseFont * _small;
    } else if (_screenWidth <= 720) {
      return _baseFont * _medium;
    } else if (_screenWidth <= 1080) {
      return _baseFont * _large;
    } else {
      return _baseFont * _xLarge;
    }
  }

  static double medium() {
    if (_screenWidth <= 480) {
      return _baseFont * _medium;
    } else if (_screenWidth <= 720) {
      return _baseFont * _medium;
    } else if (_screenWidth <= 1080) {
      return _baseFont * _xLarge;
    } else {
      return _baseFont * _xxLarge;
    }
  }

  static double large() {
    if (_screenWidth <= 480) {
      return _baseFont * _large;
    } else if (_screenWidth <= 720) {
      return _baseFont * _xLarge;
    } else if (_screenWidth <= 1080) {
      return _baseFont * _xxLarge;
    } else {
      return _baseFont * _xxLarge;
    }
  }
  static double xLarge(){
    if (_screenWidth <= 480) {
      return _baseFont * _xLarge;
    } else if (_screenWidth <= 720) {
      return _baseFont * _xxxLarge;
    } else if (_screenWidth <= 1080) {
      return _baseFont * _xxxLarge;
    } else {
      return _baseFont * _xxxLarge;
    }

  }
}
