class Jugador {
  final int? idJugador;
  final String nombre;
  final String ciudad;
  final DateTime fechaNacimiento;
  final int idClub;
  final String? nombreClub;

  Jugador({
    this.idJugador,
    required this.nombre,
    required this.ciudad,
    required this.fechaNacimiento,
    required this.idClub,
    this.nombreClub,
  });

  factory Jugador.fromJson(Map<String, dynamic> json) {
    return Jugador(
      idJugador: json['id_jugador'] as int?,
      nombre: json['nombre'] as String,
      ciudad: json['ciudad'] as String,
      fechaNacimiento: DateTime.parse(json['fecha_nacimiento'] as String),
      idClub: json['id_club'] as int,
      nombreClub: json['club']?['nombre'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'ciudad': ciudad,
      'fecha_nacimiento': fechaNacimiento.toIso8601String().split('T').first,
      'id_club': idClub,
    };
  }

  Jugador copyWith({
    int? idJugador,
    String? nombre,
    String? ciudad,
    DateTime? fechaNacimiento,
    int? idClub,
    String? nombreClub,
  }) {
    return Jugador(
      idJugador: idJugador ?? this.idJugador,
      nombre: nombre ?? this.nombre,
      ciudad: ciudad ?? this.ciudad,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      idClub: idClub ?? this.idClub,
      nombreClub: nombreClub ?? this.nombreClub,
    );
  }
}