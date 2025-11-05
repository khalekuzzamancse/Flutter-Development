import 'dart:ui';

import 'package:features/core/ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:features/core/ui/core_ui.dart';
part '_misc.dart';
part '_screen.dart';
part '_thanks_to_ict.dart';
part '_copyright.dart';
class Constants {
  static const int expectedImageWidth = 224;
  static const int expectedImageHeight = 224;

  static bool isImageSizeMatched(Image image) {
    return image.width == expectedImageWidth &&
        image.height == expectedImageHeight;
  }
}

