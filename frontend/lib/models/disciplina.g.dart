// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disciplina.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Disciplina _$DisciplinaFromJson(Map<String, dynamic> json) => Disciplina(
  idDisciplina: (json['id_disciplina'] as num?)?.toInt(),
  nombre: json['nombre'] as String,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$DisciplinaToJson(Disciplina instance) =>
    <String, dynamic>{'nombre': instance.nombre};
