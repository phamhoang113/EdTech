import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/open_class_entity.dart';

part 'open_class_model.g.dart';

@JsonSerializable()
class OpenClassModel extends OpenClassEntity {
  const OpenClassModel({
    required super.id,
    required super.title,
    required super.subject,
    required super.grade,
    super.location,
    required super.schedule,
    super.timeFrame,
    required super.classCode,
    required super.feePercentage,
    required super.parentFee,
    required super.minTutorFee,
    required super.maxTutorFee,
    required super.tutorLevelRequirement,
    required super.genderRequirement,
    required super.sessionsPerWeek,
    required super.sessionDurationMin,
    required super.studentCount,
    super.levelFees,
  });

  factory OpenClassModel.fromJson(Map<String, dynamic> json) =>
      _$OpenClassModelFromJson(json);

  Map<String, dynamic> toJson() => _$OpenClassModelToJson(this);
}
