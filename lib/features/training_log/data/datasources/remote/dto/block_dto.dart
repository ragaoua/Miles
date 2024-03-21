part of '../api/api.dart';

@JsonSerializable()
class BlockWithDaysDTO {
  final int id;
  final String name;
  final List<DayDTO> days;

  const BlockWithDaysDTO({
    required this.id,
    required this.name,
    required this.days,
  });

  factory BlockWithDaysDTO.fromEntity(BlockWithDays block) => BlockWithDaysDTO(
        id: block.id,
        name: block.name,
        days: block.days.map((day) => DayDTO.fromEntity(day)).toList(),
      );

  factory BlockWithDaysDTO.fromJson(Map<String, dynamic> json) =>
      _$BlockWithDaysDTOFromJson(json);

  Map<String, dynamic> toJson() => _$BlockWithDaysDTOToJson(this);
}
