import 'package:flutter/foundation.dart';

class VerificationProvider with ChangeNotifier {
  bool _isVerified = false;
  bool _pendingReviewDialog = false;

  bool get isVerified => _isVerified;
  bool get pendingReviewDialog => _pendingReviewDialog;

  void completeVerification() {
    _isVerified = true;
    _pendingReviewDialog = true;
    notifyListeners();
  }

  void markDialogShown() {
    _pendingReviewDialog = false;
    notifyListeners();
  }
}
