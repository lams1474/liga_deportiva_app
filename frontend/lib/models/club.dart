import 'package:json_annotation/json_annotation.dart';

part 'club.g.dart';

@JsonSerializable()
class Club {
  @JsonKey(name: 'id_club', includeToJson: false)
  final int? idClub;

  final String nombre;
  final String ciudad;

  @JsonKey(name: 'fecha_fundacion')
  final DateTime fechaFundacion;

  // 🔥 Campos de ubicación (solo locales, NO se envían al backend)
  @JsonKey(includeToJson: false, includeFromJson: true)
  final double? latitud;

  @JsonKey(includeToJson: false, includeFromJson: true)
  final double? longitud;

  @JsonKey(name: 'precision_ubicacion', includeToJson: false, includeFromJson: true)
  final String? precisionUbicacion;

  Club({
    this.idClub,
    required this.nombre,
    required this.ciudad,
    required this.fechaFundacion,
    this.latitud,
    this.longitud,
    this.precisionUbicacion,
  });

  factory Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);
  Map<String, dynamic> toJson() => _$ClubToJson(this);

  Club copyWith({
    int? idClub,
    String? nombre,
    String? ciudad,
    DateTime? fechaFundacion,
    double? latitud,
    double? longitud,
    String? precisionUbicacion,
  }) {
    return Club(
      idClub: idClub ?? this.idClub,
      nombre: nombre ?? this.nombre,
      ciudad: ciudad ?? this.ciudad,
      fechaFundacion: fechaFundacion ?? this.fechaFundacion,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      precisionUbicacion: precisionUbicacion ?? this.precisionUbicacion,
    );
  }
}