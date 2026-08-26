class Club {
  final int? idClub;
  final String nombre;
  final String ciudad;
  final DateTime fechaFundacion;

  Club({
    this.idClub,
    required this.nombre,
    required this.ciudad,
    required this.fechaFundacion,
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      idClub: json['id_club'] as int?,
      nombre: json['nombre'] as String,
      ciudad: json['ciudad'] as String,
      fechaFundacion: DateTime.parse(json['fecha_fundacion'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'ciudad': ciudad,
      'fecha_fundacion': fechaFundacion.toIso8601String().split('T').first, // Formato YYYY-MM-DD
    };
  }

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