
import '../../library.dart';

extension ColorSchemeExtension on BuildContext {
  Color get primaryColor => Theme.of(this).colorScheme.primary;

  Color get secondaryColor => Theme.of(this).colorScheme.secondary;

  Color get onPrimaryColor => Theme.of(this).colorScheme.onPrimary;
}
