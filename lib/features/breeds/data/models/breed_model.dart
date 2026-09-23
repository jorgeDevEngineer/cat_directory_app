import 'package:freezed_annotation/freezed_annotation.dart';

part 'breed_model.freezed.dart';
part 'breed_model.g.dart';

@freezed
abstract class BreedModel with _$BreedModel {
  const factory BreedModel({
    required String breed,
    required String country,
    required String origin,
    required String coat,
    required String pattern,
  }) = _BreedModel;

  factory BreedModel.fromJson(Map<String, dynamic> json) =>
      _$BreedModelFromJson(json);
}
