class ServerResponse {
  final int code;
  final String? message;
  final Map<String, List<String>>? errors;
  //Dynamic, make sure know the data type before parsing
  final dynamic data; //Dynamic is nullable without using '?'

  ServerResponse({
    required this.code,
    this.message,
    this.errors,
    this.data,
  });

  factory ServerResponse.fromJsonOrThrow(Map<String, dynamic> json) {
    return ServerResponse(
      code: json['code'] as int,
      message: json['message'],
      errors: json['errors'] != null
          ? Map<String, List<String>>.from(json['errors'].map((key, value) =>
          MapEntry(key, List<String>.from(value))))
          : null,
      data: json.containsKey('data') ? json['data'] : null,  // Safe check for 'data'
    );
  }

  bool get isSuccess => code == 200;
  bool get isFailure => code != 200;
  bool get isTokenExpireError=>code==401;

  String? get errorMessage {
    if (isSuccess) return null;
    List<String> errorMessages = [];
    if (errors != null) {
      errors!.forEach((key, value) {
        errorMessages.addAll(value);
      });
    }
    String mergedError = errorMessages.isNotEmpty ? errorMessages.join(', ') : '';
    if (message != null && message!.isNotEmpty) {
      if (mergedError.isNotEmpty) {
        mergedError += ' - ';
      }
      mergedError += message!;
    }
    if (mergedError.isEmpty) {
      mergedError = 'Knowing error from server';
    }
    return mergedError;
  }

  String? get successMessage {
    if (isSuccess && message != null && message!.isNotEmpty) {
      return message;
    }
    return null;
  }

}
class ErrorHelper {
  final String? errorJson;

  ErrorHelper(this.errorJson);

  // Method to parse errors from JSON string representation, excluding keys
  String? parseErrors() {
    if (errorJson == null || errorJson!.isEmpty) {
      return null;  // Return null if there's no error
    }

    // Use regular expression to find error values (strings or items in arrays)
    final regExp = RegExp(r'\"([a-zA-Z0-9_]+)\"[ ]*:[ ]*(\[[^\]]+\]|\"[^\"]+\")');
    final matches = regExp.allMatches(errorJson!);

    // Extract the error message values (the content inside the quotes or array items)
    List<String> errorMessages = [];
    for (var match in matches) {
      final errorValue = match.group(2); // This will either be a string or an array

      // If it's an array, extract the values within the array
      if (errorValue!.startsWith('[')) {
        final arrayMatch = RegExp(r'\"([^\"]+)\"').allMatches(errorValue);
        for (var item in arrayMatch) {
          errorMessages.add(item.group(1)!);
        }
      } else {
        // It's a single string, so just add it directly
        final valueMatch = RegExp(r'\"([^\"]+)\"').firstMatch(errorValue);
        if (valueMatch != null) {
          errorMessages.add(valueMatch.group(1)!);
        }
      }
    }

    return errorMessages.isNotEmpty ? errorMessages.join(', ') : null;  // Return null if no errors found
  }
}

