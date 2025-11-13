import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'account_controller.dart';
import 'transaction.dart';

void main() {
  final router = Router();
  final accountController = AccountController();

  final transactionController = TransactionController();
  // Set up the route for transactions
  router.get('/transactions', transactionController.getTransactions);
  // Set up routes for AccountController
  router.get('/active-loans', accountController.getActiveLoans);
  router.get('/cards', accountController.getCards);
  router.get('/spend-summary', accountController.getSpendSummary);
  router.get('/breakdowns', accountController.getBreakdowns);
  router.get('/spend-data', accountController.getSpendData);

  // Create the server
  var handler = const Pipeline().addMiddleware(logRequests()).addHandler(router);

  // Start the server on port 8080
  serve(handler, InternetAddress.anyIPv4, 8080).then((server) {
    print('Server running at http://localhost:8080');
  });
}
