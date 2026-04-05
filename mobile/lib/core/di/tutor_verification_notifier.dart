import 'package:flutter/foundation.dart';

/// Global notifier for tutor verification status.
/// Used by MainShell to block tab navigation when tutor is UNVERIFIED.
class TutorVerificationNotifier extends ValueNotifier<String> {
  TutorVerificationNotifier() : super('');

  /// Statuses: '', 'UNVERIFIED', 'PENDING', 'APPROVED', 'REJECTED'
  bool get isBlocked => value == 'UNVERIFIED';

  void updateStatus(String status) {
    value = status;
  }

  void clear() {
    value = '';
  }
}
