import 'package:json_annotation/json_annotation.dart';

part 'club.g.dart';

@JsonSerializable()
class Club {
  @JsonKey(name: 'id_club', includeToJson: false)  // 🔥 NO incluir en toJson
  final int? idClub;

  final String nombre;
  final String ciudad;

  @JsonKey(name: 'fecha_fundacion')
  final DateTime fechaFundacion;

  Club({
    this.idClub,
    required this.nombre,
    required this.ciudad,
    required this.fechaFundacion,
  });

  factory Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);
  Map<String, dynamic> toJson() => _$ClubToJson(this);

  Club copyWith({
    int? idClub,
    String? nombre,
    String? ciudad,
    DateTime? fechaFundacion,
  }) {
    return Club(
      idClub: idClub ?? this.idClub,
      nombre: nombre ?? this.nombre,
      ciudad: ciudad ?? this.ciudad,
      fechaFundacion: fechaFundacion ?? this.fechaFundacion,
    );
  }
}