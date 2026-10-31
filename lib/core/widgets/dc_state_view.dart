import 'package:flutter/material.dart';

import 'app_empty.dart';
import 'app_error.dart';
import 'app_loading.dart';

/// Status view serbaguna untuk menangani 5 status data (Loading, No Internet, Server Error, Empty, Success).
enum DcViewState {
  loading,
  noInternet,
  serverError,
  empty,
  success,
}

/// Helper container yang secara otomatis merender widget yang tepat berdasarkan status data.
class DcStateView extends StatelessWidget {
  const DcStateView({
    super.key,
    required this.state,
    required this.child,
    this.onRetry,
    this.loadingMessage,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyIcon,
    this.emptyActionLabel,
    this.onEmptyAction,
  });

  final DcViewState state;
  final Widget child;
  final VoidCallback? onRetry;
  final String? loadingMessage;
  final String? emptyTitle;
  final String? emptySubtitle;
  final IconData? emptyIcon;
  final String? emptyActionLabel;
  final VoidCallback? onEmptyAction;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      DcViewState.loading => DcLoadingState(message: loadingMessage),
      DcViewState.noInternet => DcNoInternetState(onRetry: onRetry),
      DcViewState.serverError => DcServerErrorState(onRetry: onRetry),
      DcViewState.empty => DcEmptyState(
          title: emptyTitle,
          subtitle: emptySubtitle,
          icon: emptyIcon,
          actionLabel: emptyActionLabel,
          onAction: onEmptyAction,
        ),
      DcViewState.success => child,
    };
  }
}

