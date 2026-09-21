import 'package:json_annotation/json_annotation.dart';

part 'partido.g.dart';

@JsonSerializable()
class Partido {
  @JsonKey(name: 'id_partido', includeToJson: false)
  final int? idPartido;

  final DateTime fecha;
  final String hora;
  final String lugar;

  @JsonKey(name: 'id_categoria')
  final int idCategoria;

  @JsonKey(name: 'id_club_local')
  final int idClubLocal;

  @JsonKey(name: 'id_club_visitante')
  final int idClubVisitante;

  @JsonKey(name: 'id_temporada')
  final int idTemporada;

  @JsonKey(name: 'id_arbitro')
  final int idArbitro;

  @JsonKey(name: 'programado_por')
  final int programadoPor;

  // 🔥 Datos anidados del backend (solo lectura)
  @JsonKey(name: 'categoria', includeToJson: false)
  final Map<String, dynamic>? categoriaData;

  @JsonKey(name: 'club_local', includeToJson: false)
  final Map<String, dynamic>? clubLocalData;

  @JsonKey(name: 'club_visitante', includeToJson: false)
  final Map<String, dynamic>? clubVisitanteData;

  @JsonKey(name: 'temporada', includeToJson: false)
  final Map<String, dynamic>? temporadaData;

  @JsonKey(name: 'arbitro', includeToJson: false)
  final Map<String, dynamic>? arbitroData;

  @JsonKey(name: 'programador', includeToJson: false)
  final Map<String, dynamic>? programadorData;

  @JsonKey(name: 'created_at', includeToJson: false, includeFromJson: true)
  final String? createdAt;

  @JsonKey(name: 'updated_at', includeToJson: false, includeFromJson: true)
  final String? updatedAt;

  Partido({
    this.idPartido,
    required this.fecha,
    required this.hora,
    required this.lugar,
    required this.idCategoria,
    required this.idClubLocal,
    required this.idClubVisitante,
    required this.idTemporada,
    required this.idArbitro,
    required this.programadoPor,
    this.categoriaData,
    this.clubLocalData,
    this.clubVisitanteData,
    this.temporadaData,
    this.arbitroData,
    this.programadorData,
    this.createdAt,
    this.updatedAt,
  });

  // 🔥 Getters de conveniencia para mostrar nombres en la UI
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get nombreCategoria => (categoriaData?['nombre'] ?? 'Sin categoría') as String;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String get nombreClubLocal => (clubLocalData?['nombre'] ?? 'Sin club') as String;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String get nombreClubVisitante => (clubVisitanteData?['nombre'] ?? 'Sin club') as String;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String get nombreArbitro => (arbitroData?['nombre'] ?? 'Sin árbitro') as String;

  @JsonKey(includeFromJson: false, includeToJson: false)
  int? get anioTemporada {
    final anio = temporadaData?['año'];
    if (anio is int) return anio;
    if (anio is String) return int.tryParse(anio);
    return null;
  }

  factory Partido.fromJson(Map<String, dynamic> json) => _$PartidoFromJson(json);
  Map<String, dynamic> toJson() => _$PartidoToJson(this);

  Partido copyWith({
    int? idPartido,
    DateTime? fecha,
    String? hora,
    String? lugar,
    int? idCategoria,
    int? idClubLocal,
    int? idClubVisitante,
    int? idTemporada,
    int? idArbitro,
    int? programadoPor,
    Map<String, dynamic>? categoriaData,
    Map<String, dynamic>? clubLocalData,
    Map<String, dynamic>? clubVisitanteData,
    Map<String, dynamic>? temporadaData,
    Map<String, dynamic>? arbitroData,
    Map<String, dynamic>? programadorData,
    String? createdAt,
    String? updatedAt,
  }) {
    return Partido(
      idPartido: idPartido ?? this.idPartido,
      fecha: fecha ?? this.fecha,
      hora: hora ?? this.hora,
      lugar: lugar ?? this.lugar,
      idCategoria: idCategoria ?? this.idCategoria,
      idClubLocal: idClubLocal ?? this.idClubLocal,
      idClubVisitante: idClubVisitante ?? this.idClubVisitante,
      idTemporada: idTemporada ?? this.idTemporada,
      idArbitro: idArbitro ?? this.idArbitro,
      programadoPor: programadoPor ?? this.programadoPor,
      categoriaData: categoriaData ?? this.categoriaData,
      clubLocalData: clubLocalData ?? this.clubLocalData,
      clubVisitanteData: clubVisitanteData ?? this.clubVisitanteData,
      temporadaData: temporadaData ?? this.temporadaData,
      arbitroData: arbitroData ?? this.arbitroData,
      programadorData: programadorData ?? this.programadorData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}