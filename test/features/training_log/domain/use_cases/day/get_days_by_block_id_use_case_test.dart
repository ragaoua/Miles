import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miles/features/training_log/domain/entities/day.dart';
import 'package:miles/features/training_log/domain/entities/exercise.dart';
import 'package:miles/features/training_log/domain/entities/session.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/day/get_day_by_block_id_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../core/mock_failure.dart';
import '../../repository/mock_repository.dart';

void main() {
  late Repository mockRepository;
  late GetDaysByBlockIdUseCase getDaysByBlockId;
  final random = Random();

  setUp(() {
    mockRepository = MockRepository();
    getDaysByBlockId = GetDaysByBlockIdUseCase(mockRepository);
  });

  const blockId = 1;

  test(
    "should get all blocks from the repository",
    () async {
      // arrange
      final days = List.generate(
        3,
        (dayIndex) =>
            DayWithSessions<SessionWithExercises<ExerciseWithMovementAndSets>>(
          id: random.nextInt(1000),
          blockId: blockId,
          order: dayIndex + 1,
          sessions: const [],
        ),
      );
      when(
        () => mockRepository.getDaysByBlockId(blockId),
      ).thenAnswer(
        (_) async => Right(days),
      );

      // act
      final result = await getDaysByBlockId(blockId);

      // assert
      expect(result, Right(days));
      verify(
        () => mockRepository.getDaysByBlockId(blockId),
      );
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    "should propagate repository failure",
    () async {
      final failure = MockFailure();

      // arrange
      when(
        () => mockRepository.getDaysByBlockId(blockId),
      ).thenAnswer(
        (_) async => Left(failure),
      );

      // act
      final result = await getDaysByBlockId(blockId);

      // assert
      expect(result, Left(failure));
      verify(
        () => mockRepository.getDaysByBlockId(blockId),
      );
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
