import 'package:json_annotation/json_annotation.dart';

part 'resultado.g.dart';

@JsonSerializable()
class Resultado {
  @JsonKey(name: 'id_resultado', includeToJson: false)
  final int? idResultado;

  @JsonKey(name: 'id_partido')
  final int idPartido;

  @JsonKey(name: 'marcador_local')
  final int? marcadorLocal;

  @JsonKey(name: 'marcador_visitante')
  final int? marcadorVisitante;

  @JsonKey(name: 'registrado_por')
  final int registradoPor;

  // 🔥 Datos anidados del backend (solo lectura)
  @JsonKey(name: 'partido', includeToJson: false)
  final Map<String, dynamic>? partidoData;

  @JsonKey(name: 'registrador', includeToJson: false)
  final Map<String, dynamic>? registradorData;

  @JsonKey(name: 'created_at', includeToJson: false, includeFromJson: true)
  final String? createdAt;

  @JsonKey(name: 'updated_at', includeToJson: false, includeFromJson: true)
  final String? updatedAt;

  Resultado({
    this.idResultado,
    required this.idPartido,
    this.marcadorLocal,
    this.marcadorVisitante,
    required this.registradoPor,
    this.partidoData,
    this.registradorData,
    this.createdAt,
    this.updatedAt,
  });

  // 🔥 Getters de conveniencia
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get nombreRegistrador => (registradorData?['nombre'] ?? 'Desconocido') as String;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String get descripcionMarcador {
    if (marcadorLocal == null || marcadorVisitante == null) {
      return 'Sin marcador';
    }
    return '$marcadorLocal - $marcadorVisitante';
  }

  factory Resultado.fromJson(Map<String, dynamic> json) => _$ResultadoFromJson(json);
  Map<String, dynamic> toJson() => _$ResultadoToJson(this);

  Resultado copyWith({
    int? idResultado,
    int? idPartido,
    int? marcadorLocal,
    int? marcadorVisitante,
    int? registradoPor,
    Map<String, dynamic>? partidoData,
    Map<String, dynamic>? registradorData,
    String? createdAt,
    String? updatedAt,
  }) {
    return Resultado(
      idResultado: idResultado ?? this.idResultado,
      idPartido: idPartido ?? this.idPartido,
      marcadorLocal: marcadorLocal ?? this.marcadorLocal,
      marcadorVisitante: marcadorVisitante ?? this.marcadorVisitante,
      registradoPor: registradoPor ?? this.registradoPor,
      partidoData: partidoData ?? this.partidoData,
      registradorData: registradorData ?? this.registradorData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}