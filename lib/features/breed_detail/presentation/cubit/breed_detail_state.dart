import 'package:equatable/equatable.dart';
import '../../data/models/cat_fact_model.dart';

abstract class BreedDetailState extends Equatable {
  const BreedDetailState();

  @override
  List<Object?> get props => [];
}

class BreedDetailInitial extends BreedDetailState {
  const BreedDetailInitial();
}

class BreedDetailFactLoading extends BreedDetailState {
  const BreedDetailFactLoading();
}

class BreedDetailFactLoaded extends BreedDetailState {
  final CatFactModel fact;

  const BreedDetailFactLoaded(this.fact);

  @override
  List<Object?> get props => [fact];
}

class BreedDetailFactError extends BreedDetailState {
  final String message;

  const BreedDetailFactError(this.message);

  @override
  List<Object?> get props => [message];
}
