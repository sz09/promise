import 'package:humanizer/humanizer.dart';
import 'package:promise/resources/localization/l10n.dart';

extension Prettify on String {
  /// Shortens a long string by taking the start n chars (5 is default)
  /// and the last n chars (if long enough). Useful for logging/printing.
  String shortenForPrint([int n = 5]) {
    if (length <= 2 * n) {
      return this;
    } else {
      return '${substring(0, n)}...${substring(length - n)}';
    }
  }
}

extension Plural on Type {
  String toPlural() {
    // Only use in system objects
    return toString().toPluralForm(locale: EN.languageCode);
  }
}