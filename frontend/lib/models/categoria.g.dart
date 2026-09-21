// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categoria.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Categoria _$CategoriaFromJson(Map<String, dynamic> json) => Categoria(
  idCategoria: (json['id_categoria'] as num?)?.toInt(),
  nombre: json['nombre'] as String,
  idDisciplina: (json['id_disciplina'] as num).toInt(),
  disciplinaData: json['disciplina'] == null
      ? null
      : Disciplina.fromJson(json['disciplina'] as Map<String, dynamic>),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$CategoriaToJson(Categoria instance) => <String, dynamic>{
  'nombre': instance.nombre,
  'id_disciplina': instance.idDisciplina,
};
