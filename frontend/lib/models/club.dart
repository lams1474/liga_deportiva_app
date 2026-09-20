import 'package:json_annotation/json_annotation.dart';

part 'club.g.dart';

@JsonSerializable()
class Club {
  @JsonKey(name: 'id_club', includeToJson: false)
  final int? idClub;

  final String nombre;
  final String ciudad;

  // 🔥 Presidente (String?)
  final String? presidente;

  @JsonKey(name: 'fecha_fundacion')
  final DateTime fechaFundacion;

  // 🔥 AHORA SÍ se envían al backend
  final double? latitud;
  final double? longitud;

  @JsonKey(name: 'precision_ubicacion')
  final String? precisionUbicacion;

  Club({
    this.idClub,
    required this.nombre,
    required this.ciudad,
    this.presidente,
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
    String? presidente,
    DateTime? fechaFundacion,
    double? latitud,
    double? longitud,
    String? precisionUbicacion,
  }) {
    return Club(
      idClub: idClub ?? this.idClub,
      nombre: nombre ?? this.nombre,
      ciudad: ciudad ?? this.ciudad,
      presidente: presidente ?? this.presidente,
      fechaFundacion: fechaFundacion ?? this.fechaFundacion,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      precisionUbicacion: precisionUbicacion ?? this.precisionUbicacion,
    );
  }
}