
import 'package:intl/intl.dart';
import 'core_language.dart';

class DateTimeUtils {
  static const tag="DateTimeUtils";
  static String formatDateAndTimeOrOriginal(String inputTimestamp) {
    try{
      final parsedDateTime = DateTime.parse(inputTimestamp);
      final formattedDate = DateFormat('dd/MM/yyyy').format(parsedDateTime);
      final formattedTime = DateFormat('hh:mma').format(parsedDateTime);
      final dateTime = '$formattedDate, $formattedTime';
      return dateTime;
    }
    catch(_){
    return  inputTimestamp;
    }
  }


  static String exactDateOrOriginal(String input) {
    List<String> possibleFormats = [
      "dd/MM/yyyy hh:mma",
      "dd/MM/yyyy hh:mm a",
      "dd-MM-yyyy hh:mma",
      "dd-MM-yyyy hh:mm a",
      "dd.MM.yyyy hh:mma",
      "dd.MM.yyyy hh:mm a",
      "dd/MM/yyyy HH:mm", // 24-hour format
      "dd MMM yyyy hh:mma", // e.g., "02 May 2023 7:20 PM"
      "dd MMM yyyy hh:mm a" // e.g., "02 May 2023 7:20 PM"
    ];

    // Try parsing with the defined formats first
    for (var format in possibleFormats) {
      try {
        DateTime parsedDate = DateFormat(format).parse(input.trim());
        return DateFormat('dd/MM/yyyy').format(parsedDate);
      } catch (_) {
        continue;
      }
    }

    // Try parsing ISO 8601 format (e.g., "2025-03-11T12:11:42.570343+06:00")
    try {
      DateTime parsedDate = DateTime.parse(input.trim());
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (_) {
      // If parsing fails, return the original input
    }

    Logger.on(tag, "input:$input error: Failed to parse date");
    return input;
  }


  static String getDateOnly(String inputTimestamp) {
    if (inputTimestamp.isEmpty) {
      return "";
    }
    final parsedDateTime = DateTime.parse(inputTimestamp);
    final formattedDate = DateFormat('dd/MM/yyyy').format(parsedDateTime);
    return formattedDate;
  }

  static String extractTimeOrOriginal(String inputTimestamp) {
    if (inputTimestamp.trim().isEmpty) {
      return "";
    }

    List<String> possibleFormats = [
      "dd/MM/yyyy hh:mma",   // e.g., 02/05/2023 07:20pm
      "dd/MM/yyyy hh:mm a",  // e.g., 02/05/2023 07:20 PM
      "dd-MM-yyyy hh:mma",   // e.g., 02-05-2023 07:20pm
      "dd-MM-yyyy hh:mm a",  // e.g., 02-05-2023 07:20 PM
      "dd.MM.yyyy hh:mma",   // e.g., 02.05.2023 07:20pm
      "dd.MM.yyyy hh:mm a",  // e.g., 02.05.2023 07:20 PM
      "dd/MM/yyyy HH:mm",    // e.g., 02/05/2023 19:20 (24-hour format)
      "dd-MM-yyyy HH:mm",    // e.g., 02-05-2023 19:20
      "dd MMM yyyy hh:mma",  // e.g., 02 May 2023 07:20pm
      "dd MMM yyyy hh:mm a", // e.g., 02 May 2023 07:20 PM
      "yyyy-MM-ddTHH:mm:ss", // e.g., ISO 8601 format like "2023-05-02T19:20:00"
      "yyyy/MM/dd HH:mm",    // e.g., 2023/05/02 19:20
      "MM/dd/yyyy hh:mma",   // e.g., US format like "05/02/2023 07:20 PM"
      "MM-dd-yyyy hh:mma",   // e.g., 05-02-2023 07:20pm
      "yyyy/MM/dd hh:mma",   // e.g., 2023/05/02 07:20 PM
      "EEE, dd MMM yyyy HH:mm:ss z", // e.g., Tue, 02 May 2023 19:20:00 GMT
    ];

    for (var format in possibleFormats) {
      try {
        DateTime parsedDate = DateFormat(format).parse(inputTimestamp.trim());
        return DateFormat('hh:mma').format(parsedDate); // Return time only
      } catch (_) {
        continue;
      }
    }

    return inputTimestamp; // Return original if parsing fails
  }

}
