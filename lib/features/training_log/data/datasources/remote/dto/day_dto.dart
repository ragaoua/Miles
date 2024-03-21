part of '../api/api.dart';

@JsonSerializable()
class DayDTO {
  final int id;
  final int blockId;
  final int order;

  const DayDTO({
    required this.id,
    required this.blockId,
    required this.order,
  });

  factory DayDTO.fromEntity(Day day) =>
      DayDTO(id: day.id, blockId: day.blockId, order: day.order);

  factory DayDTO.fromJson(Map<String, dynamic> json) => _$DayDTOFromJson(json);

  Map<String, dynamic> toJson() => _$DayDTOToJson(this);
}
