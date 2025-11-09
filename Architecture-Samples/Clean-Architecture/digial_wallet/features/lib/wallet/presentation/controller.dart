
import 'package:features/core/core_presentation_logic.dart';
import 'package:features/home/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import '../domain/model/break_down_model.dart';
import '../domain/model/spend_model.dart';

abstract class Controller implements CoreController {
  Stream<List<BreakdownModel>> get breakdowns;
  Stream<SpendModel?> get spendData;
  List<CardInfo> get cards;
  ///read both recent spend and breakdown source
  void read();

}