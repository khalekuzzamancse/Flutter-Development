/**
 * Represents a server feedback entity which is typically used to handle
 * responses from the server, especially when the server provides feedback in
 * the form of a message, commonly either indicating success, failure, or other 
 * feedback.
 *
 * Most of the time, 99% of server responses follow this simple JSON format:
 * ```json
 * { "message": "string" }
 * ```
 * - Defining this entity here reduces the burden on individual feature modules 
 *   to repeatedly parse this common feedback structure, ensuring consistency 
 *   and maintaining a single source of truth for server responses.
 * 
 * - However, if your server returns a different JSON structure, you can either 
 *   edit this entity accordingly or use the generic [readParseOrThrow] method 
 *   to parse a custom JSON into the appropriate type.
 *
 * - By default, this class simplifies the common case, saving time and effort 
 *   when working with standard server messages.
 */

class ServerFeedback {
  final String message;

  ServerFeedback({required this.message});

  factory ServerFeedback.fromJson(Map<String, dynamic> json) {
    return ServerFeedback(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }

  @override
  String toString() {
    return 'ServerFeedback: { message: $message }';
  }
}
