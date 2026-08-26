class Usuario {
  final int? idUsuario;
  final String correo;      // ← CORREGIDO: antes era 'email'
  final String nombre;
  final String? rol;

  Usuario({
    this.idUsuario,
    required this.correo,
    required this.nombre,
    this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    print('📦 Parseando Usuario: $json');
    
    return Usuario(
      idUsuario: json['id_usuario'] as int?,
      correo: json['correo']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      rol: json['rol']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_usuario': idUsuario,
      'correo': correo,
      'nombre': nombre,
      'rol': rol,
    };
  }
}