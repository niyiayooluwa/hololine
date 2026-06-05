import 'package:flutter/material.dart';
import 'package:hololine_flutter/core/errors/failures.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Call this anywhere you have a BuildContext and a Failure.
/// Automatically picks the right title and description.
void showErrorToast(BuildContext context, Failure failure) {
  final (title, description) = _toastContent(failure);
  ShadToaster.of(context).show(
    ShadToast.destructive(title: Text(title), description: Text(description)),
  );
}

void showSuccessToast(BuildContext context, String message) {
  ShadToaster.of(context).show(ShadToast(title: Text(message)));
}

(String, String) _toastContent(Failure failure) {
  return switch (failure) {
    NetworkFailure() => ('No Internet', failure.message),
    AuthFailure() => ('Authentication Error', failure.message),
    NotFoundFailure() => ('Not Found', failure.message),
    PermissionDeniedFailure() => ('Permission Denied', failure.message),
    ConflictFailure() => ('Conflict', failure.message),
    InvalidStateFailure() => ('Invalid Action', failure.message),
    InsufficientStockFailure() => ('Insufficient Stock', failure.message),
    DuplicateSkuFailure() => ('Duplicate SKU', failure.message),
    CurrencyMismatchFailure() => ('Currency Mismatch', failure.message),
    ServerFailure() => ('Server Error', failure.message),
  };
}
