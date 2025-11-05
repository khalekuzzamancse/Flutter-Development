import 'package:flutter/cupertino.dart';

class KeyboardUtils {
  final FocusNode _focusNode = FocusNode();

  void showKeyboard(BuildContext context) {
    try {
      FocusScope.of(context).requestFocus(_focusNode);
    } catch (_) {}
  }

  void hideKeyboard(BuildContext context) {
    try {
      FocusScope.of(context).unfocus();
    } catch (_) {}
  }

  FocusNode get focusNode => _focusNode;
}