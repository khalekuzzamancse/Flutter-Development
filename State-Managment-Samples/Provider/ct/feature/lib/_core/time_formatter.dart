class TimeFormatter{

  ///Handle exception is parse failed return the original once
  static String formatTimestamp(String timestamp) {
    try {
      // Parse the timestamp into DateTime object
      DateTime dateTime = DateTime.parse(timestamp).toLocal(); // Ensure local timezone conversion


      // Manually format the DateTime object
      String month = _getMonthName(dateTime.month);
      String day = dateTime.day.toString().padLeft(2, '0');
      String year = dateTime.year.toString();
      int hour12 = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12; // Convert to 12-hour format
      String hour = hour12.toString().padLeft(2, '0');
      String minute = dateTime.minute.toString().padLeft(2, '0');
      String amPm = dateTime.hour >= 12 ? 'PM' : 'AM';

      // Construct formatted date string
      String formattedTime = "$month $day, $year, $hour:$minute $amPm";


      return formattedTime;
    } catch (e) {

      return timestamp; // Return original timestamp if error occurs
    }

  }
  /// Formats a timestamp into a human-readable string with enhanced logic.
  /// If parsing fails, it returns the original timestamp.
  static String formatReadableTimestamp(String timestamp) {
    try {
      // Parse the timestamp into DateTime object
      DateTime dateTime = DateTime.parse(timestamp).toLocal(); // Ensure local timezone conversion

      // Get the current time for comparison
      DateTime now = DateTime.now();
      Duration difference = now.difference(dateTime);

      // Determine the formatted time string based on conditions
      if (difference.inMinutes < 1) {
        // If the difference is less than 1 minute, show "now"
        return "Now";
      } else if (dateTime.day == now.day &&
          dateTime.month == now.month &&
          dateTime.year == now.year) {
        // If the date is today, show "today"
        int hour12 = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12; // Convert to 12-hour format
        String hour = hour12.toString().padLeft(2, '0');
        String minute = dateTime.minute.toString().padLeft(2, '0');
        String amPm = dateTime.hour >= 12 ? 'PM' : 'AM';
        return "Today at $hour:$minute $amPm";
      } else {
        // Manually format the DateTime object
        String month = _getMonthName(dateTime.month);
        String day = dateTime.day.toString().padLeft(2, '0');
        String year = dateTime.year.toString();
        int hour12 = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12; // Convert to 12-hour format
        String hour = hour12.toString().padLeft(2, '0');
        String minute = dateTime.minute.toString().padLeft(2, '0');
        String amPm = dateTime.hour >= 12 ? 'PM' : 'AM';

        // Construct formatted date string
        String formattedTime = "$month $day, $year, $hour:$minute $amPm";


        return formattedTime;
      }
    } catch (e) {
      return timestamp; // Return original timestamp if error occurs
    }
  }

// Helper function to get month name from month number
  static String _getMonthName(int month) {
    List<String> monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month - 1];
  }

}
String extractFileName(String filePath) {
  int lastSlashIndex = filePath.lastIndexOf(RegExp(r'[\\/]', multiLine: true));
  if (lastSlashIndex == -1) {
    // No '/' or '\' found, meaning the filePath is just a file name
    return filePath;
  } else {
    return filePath.substring(lastSlashIndex + 1);
  }

}
String parseWithEmojiOrOriginal(String value){
  try{
    return Uri.decodeComponent(value);
  }
  catch(_){
    return value;
  }
}
String encodeWithEmojiOrOriginal(String value){
  try{
    return Uri.encodeComponent(value);
  }
  catch(_){
    return value;
  }
}