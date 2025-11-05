
part of 'remote_data_source.dart';
class ServerResponse {
  final int code;
  final String? message;
  final String? errorMessage;

  //Dynamic, make sure know the data type before parsing
  final dynamic data; //Dynamic is nullable without using '?'

  ServerResponse({
    required this.code,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory ServerResponse.fromJsonOrThrow(Map<String, dynamic> json) {
    return ServerResponse(
      code: json['code'],
      message: json['message'],
      errorMessage: ErrorParser.create(jsonEncode(json['errors'])).parseErrors(),
      data: json.containsKey('data')
          ? json['data']
          : null, // Safe check for 'data'
    );
  }

  bool get isSuccess => code == 200;
  bool get isCreated=>code==201;

  bool get isFailure => code != 200;

  bool get isTokenExpireError => code == 401;

  String? get successMessage {
    if (isSuccess && message != null && message!.isNotEmpty) {
      return message;
    }
    return null;
  }

  String? getNextUrlOrNull() {
    try {
      return data['next'];
    } catch (_) {
      return null;
    }
  }
  String? getErrorOrMsgBoth(){
    try{
      if(errorMessage!=null&&message==null)
      {
        return errorMessage;
      }
      if(errorMessage!=null&&message!=null){
        return "Error:$errorMessage , msg:$message";
      }
      if(errorMessage==null&&message!=null){
        return message;
      }
      return null;
    }
    catch(_){
      return null;
    }


  }
}
abstract class ErrorParser {
  String? parseErrors();
  static ErrorParser create(String? errorJson)=>_ErrorHelperImpl1(errorJson);

}

class _ErrorHelperImpl1 implements ErrorParser{
  final String? errorJson;

  _ErrorHelperImpl1(this.errorJson);

  // Method to parse errors from JSON string representation, excluding keys
  @override
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



int getCountOrZero(Map<String, dynamic> data) {
  try {
    Logger.off('getTotalPageOrZero', 'totalPage:${data['total_pages']}');
    return data['count'];
  } catch (_) {
    Logger.off('getTotalPageOrZero', 'totalPage:catch:0}');
    return 0;
  }
}
class _ErrorHelperImpl2 implements ErrorParser {
  final String? errorJson;

  _ErrorHelperImpl2(this.errorJson);

  // Method to parse errors from JSON string representation, excluding keys
  @override
  String? parseErrors() {
    if (errorJson == null || (errorJson!).isEmpty) {
      return null;  // Return null if there's no error
    }

    return errorJson;
  }
}


int getTotalPageOrZero(Map<String, dynamic> data) {
  try {
    Logger.off('getTotalPageOrZero', 'totalPage:${data['total_pages']}');
    return data['total_pages'];
  } catch (_) {
    Logger.off('getTotalPageOrZero', 'totalPage:catch:0}');
    return 0;
  }
}