import 'package:json_annotation/json_annotation.dart';

part 'disciplina.g.dart';

@JsonSerializable()
class Disciplina {
  @JsonKey(name: 'id_disciplina', includeToJson: false)
  final int? idDisciplina;

  final String nombre;

  @JsonKey(name: 'created_at', includeToJson: false, includeFromJson: true)
  final String? createdAt;

  @JsonKey(name: 'updated_at', includeToJson: false, includeFromJson: true)
  final String? updatedAt;

  Disciplina({
    this.idDisciplina,
    required this.nombre,
    this.createdAt,
    this.updatedAt,
  });

  factory Disciplina.fromJson(Map<String, dynamic> json) =>
      _$DisciplinaFromJson(json);

  Map<String, dynamic> toJson() => _$DisciplinaToJson(this);

  Disciplina copyWith({
    int? idDisciplina,
    String? nombre,
    String? createdAt,
    String? updatedAt,
  }) {
    return Disciplina(
      idDisciplina: idDisciplina ?? this.idDisciplina,
      nombre: nombre ?? this.nombre,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}