import 'custom_exception.dart';

class DuplicateRecordException extends CustomException {
  DuplicateRecordException({
    String message = "Exists already, Consider updating or deleting old one",
    String debugMessage = "Attempt to insert an existing record for entity",
  }) : super(message: message, debugMessage: debugMessage, code: "DE-DRE");

  @override
  String toString() {
    return super.toString();
  }
}

class RecordNotFoundException extends CustomException {
  RecordNotFoundException({
    String message = "No record found for the given criteria.",
    String debugMessage = "Query returned no results for the provided primary key, document ID, or custom query.",
  }) : super(message: message, debugMessage: debugMessage, code: "DE-RNFE");

  @override
  String toString() {
    return super.toString();
  }
}

class DatabaseCanNotCreateException extends CustomException {
  DatabaseCanNotCreateException({
    String message = "DE-DICNCE: Something went wrong",
    String debugMessage = "Failed to create or configure the database instance",
  }) : super(message: message, debugMessage: debugMessage, code: "DE-DICNCE");

  @override
  String toString() {
    return super.toString();
  }
}
