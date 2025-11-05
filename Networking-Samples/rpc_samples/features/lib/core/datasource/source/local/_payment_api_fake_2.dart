part of web_socket;




class _FakeIncomingEvent {
  static String connected() {
    return '{"status":"connected","message":"Connection established."}';
  }

  static String transactionStarted() {
    return '''
{
  "event": "CONNECT_TERMINAL_NOTIFICATION",
  "data": {
    "message": "Transaction Started"
  }
}
''';
  }

  static String cardDisplaying() {
    return '''
{
  "event": "CONNECT_TERMINAL_NOTIFICATION",
  "data": {
    "message": "GetCard Screen Displayed"
  }
}
''';
  }

  static String cardPushed() {
    return '''
{
  "event": "CONNECT_TERMINAL_NOTIFICATION",
  "data": {
    "message": "Card Pushed"
  }
}
''';
  }

  static String transactionSuccess() {
    return '''
{
  "event": "SALE_COMD_RESULT",
  "data": {
    "message": {
      "TransactionType": "SALE_AUTO",
      "UTI": "C3FDG45-CHH374-CLK2456-CAGH2G3566",
      "Amount": 1000,
      "Approved": true
    }
  }
}
''';
  }

  static String transactionCancelled() {
    return '''
{
  "event": "SALE_COMD_RESULT",
  "data": {
    "message": {
      "TransactionType": "SALE_AUTO",
      "UTI": "C3FDG45-CHH374-CLK2456-CAGH2G3566",
      "Amount": 1000,
      "Approved": false,
      "Cancelled": true
    }
  }
}
''';
  }

  static String error(String message, {int code = -32071}) {
    return '''
{
  "error": {
    "message": "$message",
    "code": $code
  }
}
''';
  }
}