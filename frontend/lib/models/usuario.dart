class Usuario {
  final int idUsuario;
  final String nombre;
  final String correo;
  final String rol;

  Usuario({
    required this.idUsuario,
    required this.nombre,
    required this.correo,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json["id_usuario"],
      nombre: json["nombre"],
      correo: json["correo"],
      rol: json["rol"],
    );
  }
}