// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class Dimensions {
  static const double FONT_SIZE_EXTRA_SMALL = 10.0;
  static const double FONT_SIZE_EIGHT = 8.0;
  static const double FONT_SIZE_EXTRA_SMALL_EST = 5.0;
  static const double FONT_SIZE_SMALL = 12.0;
  static const double FONT_SIZE_DEFAULT = 14.0;
  static const double FONT_SIZE_LARGE = 16.0;
  static const double FONT_SIZE_EXTRA_LARGE = 18.0;
  static const double FONT_SIZE_OVER_LARGE = 24.0;

  static const double PADDING_SIZE_EXTRA_SMALL = 5.0;
  static const double PADDING_SIZE_SMALL = 10.0;
  static const double PADDING_SIZE_DEFAULT = 15.0;
  static const double PADDING_SIZE_LARGE = 20.0;
  static const double PADDING_SIZE_EXTRA_LARGE = 25.0;

  static const double MARGIN_SIZE_EXTRA_SMALL = 5.0;
  static const double MARGIN_SIZE_SMALL = 10.0;
  static const double MARGIN_SIZE_DEFAULT = 15.0;
  static const double MARGIN_SIZE_LARGE = 20.0;
  static const double MARGIN_SIZE_EXTRA_LARGE = 25.0;

  static const double ICON_SIZE_EXTRA_SMALL = 12.0;
  static const double ICON_SIZE_SMALL = 18.0;
  static const double ICON_SIZE_DEFAULT = 24.0;
  static const double ICON_SIZE_LARGE = 32.0;
  static const double ICON_SIZE_EXTRA_LARGE = 40.0;
  static const double ICON_SIZE_EXTRA_MAX = 60.0;
}

double getDeviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}
