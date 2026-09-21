import 'package:json_annotation/json_annotation.dart';

part 'tabla_posiciones.g.dart';

@JsonSerializable()
class TablaPosiciones {
  @JsonKey(name: 'id_posicion', includeToJson: false)
  final int? idPosicion;

  @JsonKey(name: 'id_temporada')
  final int idTemporada;

  @JsonKey(name: 'id_club')
  final int idClub;

  final int puntos;
  final int pj;
  final int pg;
  final int pe;
  final int pp;
  final int gf;
  final int gc;

  // 🔥 Datos anidados del backend (solo lectura)
  @JsonKey(name: 'temporada', includeToJson: false)
  final Map<String, dynamic>? temporadaData;

  @JsonKey(name: 'club', includeToJson: false)
  final Map<String, dynamic>? clubData;

  TablaPosiciones({
    this.idPosicion,
    required this.idTemporada,
    required this.idClub,
    this.puntos = 0,
    this.pj = 0,
    this.pg = 0,
    this.pe = 0,
    this.pp = 0,
    this.gf = 0,
    this.gc = 0,
    this.temporadaData,
    this.clubData,
  });

  // 🔥 Getters de conveniencia
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get nombreClub => (clubData?['nombre'] ?? 'Sin club') as String;

  @JsonKey(includeFromJson: false, includeToJson: false)
  int? get anioTemporada {
    final anio = temporadaData?['año'];
    if (anio is int) return anio;
    if (anio is String) return int.tryParse(anio);
    return null;
  }

  /// Diferencia de goles
  @JsonKey(includeFromJson: false, includeToJson: false)
  int get diferenciaGoles => gf - gc;

  factory TablaPosiciones.fromJson(Map<String, dynamic> json) => _$TablaPosicionesFromJson(json);
  Map<String, dynamic> toJson() => _$TablaPosicionesToJson(this);

  TablaPosiciones copyWith({
    int? idPosicion,
    int? idTemporada,
    int? idClub,
    int? puntos,
    int? pj,
    int? pg,
    int? pe,
    int? pp,
    int? gf,
    int? gc,
    Map<String, dynamic>? temporadaData,
    Map<String, dynamic>? clubData,
  }) {
    return TablaPosiciones(
      idPosicion: idPosicion ?? this.idPosicion,
      idTemporada: idTemporada ?? this.idTemporada,
      idClub: idClub ?? this.idClub,
      puntos: puntos ?? this.puntos,
      pj: pj ?? this.pj,
      pg: pg ?? this.pg,
      pe: pe ?? this.pe,
      pp: pp ?? this.pp,
      gf: gf ?? this.gf,
      gc: gc ?? this.gc,
      temporadaData: temporadaData ?? this.temporadaData,
      clubData: clubData ?? this.clubData,
    );
  }
}