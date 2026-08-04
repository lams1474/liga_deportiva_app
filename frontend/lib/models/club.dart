class Club {

  final int idClub;
  final String nombre;
  final String ciudad;
  final String fechaFundacion;

  Club({
    required this.idClub,
    required this.nombre,
    required this.ciudad,
    required this.fechaFundacion,
  });

  factory Club.fromJson(Map<String, dynamic> json) {

    return Club(
      idClub: json["id_club"],
      nombre: json["nombre"],
      ciudad: json["ciudad"],
      fechaFundacion: json["fecha_fundacion"],
    );

  }

}