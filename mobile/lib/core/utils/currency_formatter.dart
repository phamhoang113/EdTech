/// Utility class for formatting Vietnamese currency (VND).
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Format a number to VND string with dot separators.
  /// Example: 1600000 → "1.600.000"
  static String formatVND(num value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  /// Format to compact display (K/M suffix).
  /// Example: 1600000 → "1.6M", 8000 → "8K"
  static String formatCompact(num value) {
    if (value == 0) return '0';
    if (value >= 1000000) {
      final m = value / 1000000;
      return '${m.toStringAsFixed(m == m.truncate() ? 0 : 1)}M';
    }
    if (value >= 1000) {
      final k = value / 1000;
      return '${k.toStringAsFixed(k == k.truncate() ? 0 : 1)}K';
    }
    return value.toString();
  }
}
