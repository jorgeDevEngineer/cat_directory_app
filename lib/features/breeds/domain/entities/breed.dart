import 'package:equatable/equatable.dart';

class Breed extends Equatable {
  final String breed;
  final String country;
  final String origin;
  final String coat;
  final String pattern;

  const Breed({
    required this.breed,
    required this.country,
    required this.origin,
    required this.coat,
    required this.pattern,
  });

  @override
  List<Object?> get props => [breed, country, origin, coat, pattern];
}
