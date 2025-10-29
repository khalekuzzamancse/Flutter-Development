
import 'package:auth/src/presentation/ui/login_screen.dart';
import 'package:core/network/core_network.dart';
import 'package:flutter/material.dart';

class AuthModule extends StatelessWidget {
  final Function(Json) onLoginSuccess;
  const AuthModule({super.key, required this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
   return  const Material(child: LoginScreen());

  }
}
