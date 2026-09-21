import 'package:json_annotation/json_annotation.dart';

part 'temporada.g.dart';

@JsonSerializable()
class Temporada {
  @JsonKey(name: 'id_temporada', includeToJson: false)
  final int? idTemporada;

  // 🔥 En el backend el campo se llama 'año' (con ñ)
  @JsonKey(name: 'año')
  final int anio;

  @JsonKey(name: 'created_at', includeToJson: false, includeFromJson: true)
  final String? createdAt;

  @JsonKey(name: 'updated_at', includeToJson: false, includeFromJson: true)
  final String? updatedAt;

  Temporada({
    this.idTemporada,
    required this.anio,
    this.createdAt,
    this.updatedAt,
  });

  factory Temporada.fromJson(Map<String, dynamic> json) => _$TemporadaFromJson(json);
  Map<String, dynamic> toJson() => _$TemporadaToJson(this);

  Temporada copyWith({
    int? idTemporada,
    int? anio,
    String? createdAt,
    String? updatedAt,
  }) {
    return Temporada(
      idTemporada: idTemporada ?? this.idTemporada,
      anio: anio ?? this.anio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}