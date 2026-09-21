import 'package:json_annotation/json_annotation.dart';

part 'arbitro.g.dart';

@JsonSerializable()
class Arbitro {
  @JsonKey(name: 'id_arbitro', includeToJson: false)
  final int? idArbitro;

  final String nombre;
  final String categoria;

  @JsonKey(name: 'created_at', includeToJson: false, includeFromJson: true)
  final String? createdAt;

  @JsonKey(name: 'updated_at', includeToJson: false, includeFromJson: true)
  final String? updatedAt;

  Arbitro({
    this.idArbitro,
    required this.nombre,
    required this.categoria,
    this.createdAt,
    this.updatedAt,
  });

  factory Arbitro.fromJson(Map<String, dynamic> json) => _$ArbitroFromJson(json);
  Map<String, dynamic> toJson() => _$ArbitroToJson(this);

  Arbitro copyWith({
    int? idArbitro,
    String? nombre,
    String? categoria,
    String? createdAt,
    String? updatedAt,
  }) {
    return Arbitro(
      idArbitro: idArbitro ?? this.idArbitro,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}