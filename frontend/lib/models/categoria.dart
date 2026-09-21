import 'package:json_annotation/json_annotation.dart';
import 'disciplina.dart';

part 'categoria.g.dart';

@JsonSerializable()
class Categoria {
  @JsonKey(name: 'id_categoria', includeToJson: false)
  final int? idCategoria;

  final String nombre;

  @JsonKey(name: 'id_disciplina')
  final int idDisciplina;

  // 🔥 Datos de la disciplina (vienen del backend con include)
  @JsonKey(name: 'disciplina', includeToJson: false)
  final Disciplina? disciplinaData;

  @JsonKey(name: 'created_at', includeToJson: false, includeFromJson: true)
  final String? createdAt;

  @JsonKey(name: 'updated_at', includeToJson: false, includeFromJson: true)
  final String? updatedAt;

  Categoria({
    this.idCategoria,
    required this.nombre,
    required this.idDisciplina,
    this.disciplinaData,
    this.createdAt,
    this.updatedAt,
  });

  // 🔥 Getter de conveniencia
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get nombreDisciplina => disciplinaData?.nombre;

  factory Categoria.fromJson(Map<String, dynamic> json) =>
      _$CategoriaFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriaToJson(this);

  Categoria copyWith({
    int? idCategoria,
    String? nombre,
    int? idDisciplina,
    Disciplina? disciplinaData,
    String? createdAt,
    String? updatedAt,
  }) {
    return Categoria(
      idCategoria: idCategoria ?? this.idCategoria,
      nombre: nombre ?? this.nombre,
      idDisciplina: idDisciplina ?? this.idDisciplina,
      disciplinaData: disciplinaData ?? this.disciplinaData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}