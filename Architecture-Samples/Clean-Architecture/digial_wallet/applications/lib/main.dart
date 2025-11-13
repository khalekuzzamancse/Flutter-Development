import 'dart:io';

import 'package:features/entry_point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
 HttpOverrides.global = MyHttpOverrides();
 runApp( const EntryPoint());
}
class MyHttpOverrides extends HttpOverrides {
 @override
 HttpClient createHttpClient(SecurityContext? context) {
  return super.createHttpClient(context)
   ..badCertificateCallback =
       (X509Certificate cert, String host, int port) => true;  // Accept all certificates
 }
}
