import 'package:equatable/equatable.dart';

abstract class BreedsEvent extends Equatable {
  const BreedsEvent();

  @override
  List<Object?> get props => [];
}

class BreedsLoadStarted extends BreedsEvent {
  final bool forceRefresh;
  final bool isRevalidation;

  const BreedsLoadStarted({
    this.forceRefresh = false,
    this.isRevalidation = false,
  });

  @override
  List<Object?> get props => [forceRefresh, isRevalidation];
}

class BreedsNextPageRequested extends BreedsEvent {
  const BreedsNextPageRequested();
}

class BreedsRefreshRequested extends BreedsEvent {
  const BreedsRefreshRequested();
}

class BreedsSearchQueryChanged extends BreedsEvent {
  final String query;

  const BreedsSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class BreedsConnectivityChanged extends BreedsEvent {
  final bool isConnected;

  const BreedsConnectivityChanged(this.isConnected);

  @override
  List<Object?> get props => [isConnected];
}
