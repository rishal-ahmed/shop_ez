import 'package:flutter/material.dart';

enum DeviceType { phone, tablet }

class DeviceUtil {
  //========== Singleton Instance ==========
  DeviceUtil._internal();
  static DeviceUtil instance = DeviceUtil._internal();
  factory DeviceUtil() {
    return instance;
  }

  static Enum get _getDeviceType {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    return data.size.shortestSide < 550 ? DeviceType.phone : DeviceType.tablet;
  }

  static bool get isTablet {
    return _getDeviceType == DeviceType.tablet;
  }
}