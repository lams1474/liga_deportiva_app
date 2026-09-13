import 'package:json_annotation/json_annotation.dart';

part 'jugador.g.dart';

@JsonSerializable()
class Jugador {
  @JsonKey(name: 'id_jugador', includeToJson: false)  // 🔥 NO incluir en toJson
  final int? idJugador;

  final String cedula;
  final String nombre;
  final String ciudad;

  @JsonKey(name: 'fecha_nacimiento')
  final DateTime fechaNacimiento;

  @JsonKey(name: 'id_club')
  final int idClub;

  @JsonKey(name: 'club', includeToJson: false)  // 🔥 NO incluir en toJson
  final Map<String, dynamic>? clubData;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get nombreClub => clubData?['nombre'] as String?;

  Jugador({
    this.idJugador,
    required this.cedula,
    required this.nombre,
    required this.ciudad,
    required this.fechaNacimiento,
    required this.idClub,
    this.clubData,
  });

  factory Jugador.fromJson(Map<String, dynamic> json) => _$JugadorFromJson(json);
  Map<String, dynamic> toJson() => _$JugadorToJson(this);

  Jugador copyWith({
    int? idJugador,
    String? cedula,
    String? nombre,
    String? ciudad,
    DateTime? fechaNacimiento,
    int? idClub,
    Map<String, dynamic>? clubData,
  }) {
    return Jugador(
      idJugador: idJugador ?? this.idJugador,
      cedula: cedula ?? this.cedula,
      nombre: nombre ?? this.nombre,
      ciudad: ciudad ?? this.ciudad,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      idClub: idClub ?? this.idClub,
      clubData: clubData ?? this.clubData,
    );
  }
}