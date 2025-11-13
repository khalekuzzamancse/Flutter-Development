import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'account_data.dart';
import 'core.dart';
class AccountController {
  final AccountApi accountApi=AccountApi();
  // Endpoint for Active Loans
  Future<Response> getActiveLoans(Request request) async {
    final responseJson = await accountApi.readActiveLoans();
    await delay(3000);
    return Response.ok(responseJson, headers: {'Content-Type': 'application/json'});
  }

  // Endpoint for Cards
  Future<Response> getCards(Request request) async {
    final responseJson = await accountApi.readCards();
    await delay(3000);
    return Response.ok(responseJson, headers: {'Content-Type': 'application/json'});
  }

  // Endpoint for Spend Summary
  Future<Response> getSpendSummary(Request request) async {
    final responseJson = await accountApi.readSpendSummary();
    await delay(3000);
    return Response.ok(responseJson, headers: {'Content-Type': 'application/json'});
  }

  // Endpoint for Breakdown Data
  Future<Response> getBreakdowns(Request request) async {
    final responseJson = await accountApi.readBreakdowns();
    await delay(3000);
    return Response.ok(responseJson, headers: {'Content-Type': 'application/json'});
  }

  // Endpoint for Spend Data
  Future<Response> getSpendData(Request request) async {
    final responseJson = await accountApi.readSpendData();
    await delay(3000);
    return Response.ok(responseJson, headers: {'Content-Type': 'application/json'});
  }
}
