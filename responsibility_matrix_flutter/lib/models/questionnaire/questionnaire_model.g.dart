// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_QuestionnaireModel _$$_QuestionnaireModelFromJson(
        Map<String, dynamic> json) =>
    _$_QuestionnaireModel(
      id: json['id'] as String,
      ClosedQuestions: (json['ClosedQuestions'] as List<dynamic>)
          .map((e) => AnswerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      title: json['title'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$$_QuestionnaireModelToJson(
        _$_QuestionnaireModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ClosedQuestions': instance.ClosedQuestions,
      'title': instance.title,
      'description': instance.description,
    };
