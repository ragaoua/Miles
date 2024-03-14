import 'package:dartz/dartz.dart';
import 'package:dartz_test/dartz_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miles/core/failure.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/block/helpers/block_name_validator.dart';
import 'package:miles/features/training_log/domain/use_cases/block/insert_block_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../repository/mock_repository.dart';

class MockFailure extends Failure {}

class MockBlockNameValidator extends Mock implements BlockNameValidator {}

void main() {
  late Repository mockRepository;
  late BlockNameValidator blockNameValidator;
  late InsertBlockUseCase insertBlock;

  setUp(() {
    mockRepository = MockRepository();
    blockNameValidator = MockBlockNameValidator();
    insertBlock = InsertBlockUseCase(
      repository: mockRepository,
      blockNameValidator: blockNameValidator,
    );
  });

  test("should insert a block with a valid name", () async {
    // arrange
    const blockId = 5;
    const blockName = "Valid name";
    const nbDays = 3;

    when(
      () => blockNameValidator.validate(blockName),
    ).thenAnswer((_) async => null);

    when(
      () => mockRepository.insertBlockAndDays(blockName, nbDays),
    ).thenAnswer(
      (_) async => const Right(blockId),
    );

    // act
    final result = await insertBlock(name: blockName, nbDays: nbDays);

    // assert
    expect(result.getRightOrFailTest(), blockId);
    verify(() => blockNameValidator.validate(blockName));
    verify(
      () => mockRepository.insertBlockAndDays(blockName, nbDays),
    );
    verifyNoMoreInteractions(blockNameValidator);
    verifyNoMoreInteractions(mockRepository);
  });

  test(
    "should fail when inserting a block with an invalid name",
    () async {
      // arrange
      const blockName = "Invalid name";
      final failure = MockFailure();
      when(
        () => blockNameValidator.validate(any()),
      ).thenAnswer((_) async => failure);

      // act
      final result = await insertBlock(name: blockName, nbDays: 1);

      // assert
      expect(result.getLeftOrFailTest(), failure);
      verify(() => blockNameValidator.validate(blockName));
      verifyNoMoreInteractions(blockNameValidator);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test("should propagate repository failure when inserting a block", () async {
    // arrange
    const blockName = "Block 5";
    const nbDays = 3;
    final failure = MockFailure();

    when(
      () => blockNameValidator.validate(blockName),
    ).thenAnswer((_) async => null);
    when(
      () => mockRepository.insertBlockAndDays(blockName, nbDays),
    ).thenAnswer(
      (_) async => Left(failure),
    );

    // act
    final result = await insertBlock(name: blockName, nbDays: nbDays);

    // assert
    expect(result.getLeftOrFailTest(), failure);
    verify(() => blockNameValidator.validate(blockName));
    verify(
      () => mockRepository.insertBlockAndDays(blockName, nbDays),
    );
    verifyNoMoreInteractions(blockNameValidator);
    verifyNoMoreInteractions(mockRepository);
  });
}
