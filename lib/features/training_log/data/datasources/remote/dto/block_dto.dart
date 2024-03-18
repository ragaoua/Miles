part of '../api/api.dart';

@JsonSerializable()
class BlockAndSessionDTO {
  const BlockAndSessionDTO({
    required this.id,
    required this.name,
    this.session_id,
    this.session_day_id,
    this.session_date,
  });

  factory BlockAndSessionDTO.fromJson(Map<String, dynamic> json) =>
      _$BlockAndSessionDTOFromJson(json);

  final int id;
  final String name;
  final int? session_id;
  final int? session_day_id;
  final String? session_date;

  Map<String, dynamic> toJson() => _$BlockAndSessionDTOToJson(this);
}

List<BlockWithSessions> blockAndSessionDTOListToBlockWithSessionsList(
  List<BlockAndSessionDTO> dtos,
) {
  final Map<Block, List<Session>> blockSessionsMap = {};
  for (final dto in dtos) {
    final block = Block(id: dto.id, name: dto.name);

    final blockSessions = blockSessionsMap.putIfAbsent(block, () => []);
    if (dto.session_id != null &&
        dto.session_day_id != null &&
        dto.session_date != null) {
      blockSessions.add(
        Session(
          id: dto.session_id!,
          dayId: dto.session_day_id!,
          date: DateTime.parse(dto.session_date!),
        ),
      );
    }
  }

  return BlockWithSessions.fromMapToList(blockSessionsMap);
}
