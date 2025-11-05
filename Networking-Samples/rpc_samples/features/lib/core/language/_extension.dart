part of core_language;

extension StringExt on String{
  String toTwoDecimalOrOriginal() {
    try {
      final value = double.tryParse(this);
      if (value == null) return this;
      final parts = value.toStringAsFixed(2).split('.');
      if (parts.length == 2 && parts[1].length == 1) {
        return '${parts[0]}.${parts[1]}0';
      }
      return value.toStringAsFixed(2);
    }
    catch (_) {
      return this;
    }
  }

  String cleanAndCapitalizeOrOriginal() {
    if (this == 'N/A') return this;
    final input = this;
    try {
      return input
          .replaceAll(RegExp(r'[^a-zA-Z_\- ]'), '') // Allow spaces as well
          .replaceAll(RegExp(r'[_-]'), ' ') // Replace _ and - with space
          .split(' ') // Split into words
          .map((word) =>
      word.isNotEmpty
          ? word[0].toUpperCase() + word.substring(1).toLowerCase()
          : '')
          .join(' '); // Join words with a space
    }
    catch (_) {
      return input;
    }
  }


  String formatDateAndTimeOrOriginal() {
    try {
      throw NotImplementedException();
    }
    catch (_) {
      return this;
    }
  }

  bool isEmptyOrBlank() => trim().isEmpty;

  bool isNoEmptyOrBlank() => !isEmptyOrBlank();

  String? nAtoNullOrOriginal() {
    String? input = this;

    final trimmed = input.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'n/a') {
      return null;
    }
    return input;
  }
}


extension DymanicExt on Map<String, dynamic>{
  ///if null then return 'N/A' String
  String toStringOrNA(String key) {
    final value = this[key];
    if (value == null) {
      return 'N/A';
    }
    return '$value';
  }

  String toStringOrDefault(String key, String fallback) =>
      this[key] ?? fallback;

  ///Default =-1
  int toIntOrNegativeOne(String key) => this[key] ?? -1;


}

extension DateTimeExtensions on DateTime {
  /// Returns formatted date as `YYYY-MM-DD`
  String get date {
    return "${year}-${month.toString().padLeft(2, '0')}-${day.toString()
        .padLeft(2, '0')}";
  }

  /// Returns formatted time as `HH:MM AM/PM`
  String get time {
    String amPm = hour >= 12
        ? "PM"
        : "AM"; // Determine AM/PM before modifying hour
    int hour12 = hour > 12 ? hour - 12 : (hour == 0
        ? 12
        : hour); // Convert to 12-hour format

    return "${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(
        2, '0')} $amPm";
  }
}
extension DoubleExtension on double {
  double toTwoDecimalOrOriginal() {
    try {
      return double.parse(toStringAsFixed(2));
    }
    catch (_) {
      return this;
    }
  }
}